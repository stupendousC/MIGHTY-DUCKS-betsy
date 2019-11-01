require "test_helper"

describe OrdersController do
  
  let(:m1) { merchants(:m1) }
  describe "index" do
    before do
      @merchant = merchants("m1")
    end
    it "can access an order with an order item for a merchant" do
      perform_login(@merchant)
      
      get orders_path
      must_respond_with :success      
    end
    
    it "will not access specific orders without a logged in merchant" do
      get orders_path
      
      must_redirect_to :root
      expect(flash[:error]).must_include "You must be logged in"
    end
  end
  
  describe "show" do
    it "can get an order" do
      post orders_path
      
      @order = Order.last
      get order_path(@order.id)
      
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
  
  
  ### PROBABLY CAROLINE's JOB TO DO THIS
  describe "merchants" do
    it "can display all orders with items belonging to the logged-in merchant" do
    end
    
    it "will not display an order with no items belonging to the logged-in merchant" do
    end
    
    it "will not display any orders if there is no logged-in merchant" do
    end
  end
  
  describe "CAROLINE: index" do
    it "If not logged in: redirect w/ flash msg" do
      get orders_path
      expect(session[:merchant_id]).must_be_nil
      expect(flash[:error]).must_equal "You must be logged in as a merchant"
      must_redirect_to root_path
    end
    
    describe "If logged in, can proceed..." do
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