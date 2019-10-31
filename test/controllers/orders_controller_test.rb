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
      get orders_path(@order.id)
      
      must_respond_with :redirect
      #this test doesn't work because it expects to be logged in as a merchant
      #but we shouldn't have to be logged in as a merchant
    end   
  end
  
  describe "create" do
    it "can create an order" do
      post orders_path, params: { order: { status: nil } }
      
      must_respond_with :redirect
      expect(flash[:success]).must_equal "Successfully created order"
    end
    
    it "sets the initial order status to 'pending'" do
      post orders_path, params: { order: { grand_total: 212121 } }
      
      created_order = Order.find_by(grand_total: 212121)
      expect(created_order.status).must_equal "pending"
    end
    
  end
  
  describe "update" do
    before do 
      @order = orders("o1")
    end
    
    it "updates the order if an order item is updated" do
    end
    
    it "cancels the order if all items are removed from order" do
      assert(@order.order_items.length > 0)
      
      patch order_path(@order.id), params: { order: { order_items: [] } } 
      # test returns order as nil because it's trying to get the order using the session[:order_id]
      # no idea how to fix this      
    end
    
    it "gives an error if the order can't be updated" do
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