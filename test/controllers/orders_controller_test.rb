require "test_helper"

describe OrdersController do
  
  let(:m1) { merchants(:m1) }
  let(:m2) { merchants(:m2) }
  let(:o1) { orders(:o1) }
  let(:o2) { orders(:o2) }
  let(:c1) { customers(:c1) }
  let(:oi3) { order_items(:oi3) }
  
  describe "index" do
    it "If not logged in: redirect w/ flash msg" do
      get orders_path
      expect(session[:merchant_id]).must_be_nil
      expect(flash[:error]).must_equal "You must be logged in as a merchant"
      must_redirect_to root_path
    end
    
    describe "If merchant logged in, can proceed..." do
      before do 
        perform_login(m1)
      end
      
      it "can see page" do
        get orders_path
        must_respond_with :success      
      end
      
      it "merchant can filter by all 4 different statuses" do
        # params= 0,1,2,3 bc the dragdown menu uses index of @statuses = %w[ALL SHIPPED PAID PENDING]
        4.times do |i|
          get orders_path, params: {status_selected: i}
          must_respond_with :success 
        end
      end
      
      it "merchant can request a specific customer info on page via order_item selection" do
        # fixtures: o2 has oi3/4/5, is shipped to c1 by m1 & m2
        order = Order.find_by(id: o2.id)
        expect(order.order_items).must_include oi3
        expect(order.customer).must_equal c1
        expect(oi3.product.merchant).must_equal m1
        
        puts "\n\n\nCANNOT FIGURE THIS OUT -CAROLINE"
        skip
        get orders_path, params: {order_item_id: oi3.id}
        must_respond_with :success 
      end
      
      it "merchant cannot see a customer that didn't buy anything from them" do 
        not_your_order = orders(:o4)
        not_your_order_item = not_your_order.order_items.first
        get orders_path, params: {order_item_id: not_your_order_item.id}
        must_redirect_to orders_path
        expect(flash[:error]).must_equal "Can't show you customer info for an order item that you don't own"
      end
      
      it "merchant cannot see a customer from a bogus order_item_id" do 
        get orders_path, params: {order_item_id: 0}
        must_redirect_to orders_path
        expect(flash[:error]).must_equal "That order item doesn't even exist"
      end
      
    end
    
  end
  
  describe "show" do
    # basically a VIEW_CART
    # only way to see this page is if you put stuff in your shopping cart
    # b/c that's when a session[:order_id] is given, 
    # and that's the key to unlocking this page via @order from before_action find_order()
    describe "nominal cases" do
      
      before do
        get root_path
        session[:order_id] = o1.id
        expect(o1.status).must_equal "pending"
      end
      
      it "guest can see their own valid order/shopping cart" do
        get order_path(o1)
        must_respond_with :success
      end  
      
      it "will show any missing_stocks correctly in flash" do
        deplete_this = o1.order_items.first.product
        deplete_this.update(stock: 0)
        
        get order_path(o1)
        must_respond_with :success
        expect(flash[:error]).must_equal "Uh oh! We ran out of stock on..."
        expect(flash[:error_msgs]).must_equal deplete_this.name.capitalize
      end
    end
    
    describe "edge cases" do
      it "guest cannot see another guest's valid order/shopping cart" do
        get root_path
        session[:order_id] = 0
        # because of the way we set up the before_action find_order(),
        # trepassers will actually get redirected to see their own cart instead
        get order_path(o1)
        
        must_respond_with :success
      end
      
      it "will respond with an error if order was deleted" do
        delete order_path(o1)
        expect(flash[:success]).must_equal "Successfully deleted order"
        
        get order_path(o1)
        must_respond_with :redirect
        expect(flash[:error]).must_equal "Sorry, that order is unavailable for viewing"
      end
      
      it "will respond with an error if order does not exist" do
        id = "badid"
        get order_path(id)
        
        must_respond_with :redirect
        expect(flash[:error]).must_include "That order does not exist"
      end
    end
    
    
  end
  
  describe "create" do
    it "can create an order" do
      post orders_path, params: { order: { status: nil } }
      
      must_respond_with :redirect
      expect(flash[:success]).must_equal "Successfully created order"
    end
    
    it "sets the initial order status to 'pending'" do
      expect{post orders_path, params: { order: { } }}.must_differ "Order.count", 1
      
      created_order = Order.last
      expect(created_order.status).must_equal "pending"
    end
  end
  
  describe "update" do
    before do 
      @order = orders("o1")
    end
    
    it "can update an order" do
      order_hash = {
        order: {
          order_items: []
        }
      }
      patch order_path(@order.id), params: order_hash
      
      must_respond_with :redirect
      expect(flash[:success]).must_include "Successfully updated order"
    end
  end
  
  describe "destroy" do
    before do 
      @order = orders("o1")
    end
    
    it "can destroy an order" do
      p @order
      
      p @order.nil?
      expect{delete order_path(@order.id)}.must_differ "Order.count", -1
      
      must_respond_with :redirect
      expect(flash[:success]).must_include "Successfully deleted order"
    end
  end
  
  describe "checkout" do
    
    describe "nominal case" do
      it "if has cart, can go to checkout page" do
        get root_path
        session[:order_id] = o1.id
        
        get checkout_path(id: o1.id)
        must_respond_with :success
      end
      
      it "if has cart and something is out of stock, can redirect w/ flash msg" do
        get root_path
        session[:order_id] = o1.id 
        deplete_this = o1.order_items.first.product 
        deplete_this.update(stock: 0)
        deplete_this_too = o1.order_items.last.product
        deplete_this_too.update(stock: 0)
        
        get checkout_path(id: o1.id)
        expect(flash[:error]).must_equal "Uh oh! We ran out of stock on..."
        expect(flash[:error_msgs]).must_include deplete_this.name.capitalize
        expect(flash[:error_msgs]).must_include deplete_this_too.name.capitalize  
        must_redirect_to order_path(id: o1.id)
      end
    end
    
    describe "edge cases" do
      it "if no cart, can't go to checkout page" do
        get checkout_path
        expect(flash[:error]).must_equal "You don't have anything in a shopping cart"
        must_redirect_to root_path
      end
      
      it "if had a cart then emptied it, can't go to checkout page" do
        # here I'm set up as the cart owner, but then I emptied my cart
        get root_path
        session[:order_id] = o1.id
        o1.update(order_items: [])
        expect(o1.order_items).must_equal []
        
        get checkout_path(id: o1.id)
        expect(flash[:error]).must_equal "Please actually buy something before you give us your credit card"
        must_redirect_to root_path
      end
      
      it "if cart already paid for, can't go to checkout page" do
        paid_order = orders(:o4)
        get checkout_path(id: paid_order.id)
        expect(flash[:error]).must_equal "Checkout unavailable for that order"
        must_redirect_to root_path
      end
    end
    
  end
  
  describe "CAROLINE: purchase" do
    describe "if good payment info given..." do
      it "can save new customer instance with correct attribs" do
        #TODO
      end
      
      it "correctly updates @order and @order_items statuses" do
        #TODO
      end
      
      it "sends to order_confirmation page w/ flash msg" do
        #TODO
      end   
      
    end
    
    describe "if bad payment info given..." do
      it "render same page w/ flash error msgs" do
        #TODO
      end
    end
    
    
  end
  
  describe "CAROLINE: order_confirmation" do
    describe "nominal case" do
      it "Can view order_confirmation page after payment" do
        #TODO
      end
    end
    
    describe "edge case" do
      it "Cannot view order_confirmation page before payment, if it's your cart" do
        #TODO
      end
      
      it "Cannot view order_confirmation page before payment, if not your cart" do
        #TODO    
      end
      
      it "Cannot view order_confirmation page after payment, if not your cart" do
        #TODO
      end
    end
  end
  
  describe "CAROLINE: status_ship" do
    it "can flip an order_item from paid status to shipped status" do
    end
    
    it "edge case: if order_item params is bogus, render same pg w/ flash msg" do
    end
  end
  
end