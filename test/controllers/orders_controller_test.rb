require "test_helper"

describe OrdersController do
  
  let(:m1) { merchants(:m1) }
  let(:o1) { orders(:o1) }
  let(:o2) { orders(:o2) }
  let(:c1) { customers(:c1) }
  
  describe "CAROLINE: index" do
    it "If not logged in: redirect w/ flash msg" do
      get orders_path
      expect(session[:merchant_id]).must_be_nil
      expect(flash[:error]).must_equal "You must be logged in as a merchant"
      must_redirect_to root_path
    end
    
    describe "If logged in, can proceed..." do
      
      it "can see page" do
        perform_login(m1)
        get orders_path
        must_respond_with :success      
      end
      
      it "logged-in merchant can see a specific customer info on page" do
        # fixtures: o2 has oi3/4/5, is shipped to c1 by m1 & m2
        perform_login(m1)
        order = Order.find_by(id: o2.id)
        expect(order.customer).must_equal c1
        
        ### CANNOT FIGURE IT OUT -CAROLINE
        get orders_path, params: { get_customer_via_order_id: o2.id }
        expect(@spotlight_customer).must_equal c1
        must_respond_with :success      
      end
      
      it "logged-in merchant cannot see a customer that didn't buy anything from them" do 
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
    
    describe "Not logged in guest..." do
      ### KELSEY IS DOING THIS
      it "order doesn't belong to guest, can't see page" do
        
      end
      
      it "order DOES belong to guest, can see page" do
      end
    end
    
    describe "Logged in merchant..." do
      
    end
    
      must_respond_with :success
    end   
    
    it "will respond with an error if order does not exist" do
      id = "badid"
      get order_path(id)
      
      must_respond_with :redirect
      expect(flash[:error]).must_include "That order does not exist"
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
  
  
  
  
  describe "CAROLINE: show" do
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