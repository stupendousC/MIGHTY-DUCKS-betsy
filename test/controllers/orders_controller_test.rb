require "test_helper"

describe OrdersController do
  
  let(:m1) { merchants(:m1) }
  
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
    it "updates the order if an order item is updated" do
    end
    
    it "cancels the order if all items are removed from order" do
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