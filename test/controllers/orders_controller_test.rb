require "test_helper"

describe OrdersController do
  
  let(:m1) { merchants(:m1) }
  let(:m2) { merchants(:m2) }
  let(:o1) { orders(:o1) }
  let(:o2) { orders(:o2) }
  let(:c1) { customers(:c1) }
  let(:oi3) { order_items(:oi3) }
  
  describe "CAROLINE: index" do
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
      
      it "merchant can see a specific customer info on page" do
        # fixtures: o2 has oi3/4/5, is shipped to c1 by m1 & m2
        order = Order.find_by(id: o2.id)
        expect(order.order_items).must_include oi3
        expect(order.customer).must_equal c1
        
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
    it "can get an order" do
      post orders_path
      
      @order = Order.last
      get order_path(@order.id)
      
      must_respond_with :redirect
      #this test doesn't work because it expects to be logged in as a merchant
      #but we shouldn't have to be logged in as a merchant # 
    end  
    
    it "will respond with an error if order does not exist" do
      id = "badid"
      get order_path(id)
      
      must_respond_with :redirect
      expect(flash[:error]).must_include "That order does not exist"
    end
    
    describe "Not logged in guest..." do
      ### KELSEY IS DOING THIS
      it "order doesn't belong to guest, can't see page" do
        
      end
      
      it "order DOES belong to guest, can see page" do
      end
    end
    
    describe "Logged in merchant..." do
      
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
    
    it "updates the order if an order item is updated" do
    end
    
    
    it "gives an error if the order can't be updated" do
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
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  ### PROBABLY CAROLINE's JOB TO DO THIS
  describe "merchants" do
    it "can display all orders with items belonging to the logged-in merchant" do
    end
    
    it "will not display an order with no items belonging to the logged-in merchant" do
    end
    
    it "will not display any orders if there is no logged-in merchant" do
    end
  end
  
  
  
  describe "CAROLINE: checkout" do
    it "can go to checkout page" do
      # get checkout_path
      # must_respond_with :success
    end
    
  end
  
  describe "CAROLINE: purchase" do
  end
  
  describe "CAROLINE: order_confirmation" do
  end
  
end