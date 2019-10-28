require "test_helper"

describe OrdersController do
  
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
    
  end
  
  
  # describe "VIEW_CART" do
  #   it "can go to view_cart page" do
  #     get view_cart_path
  #     must_respond_with :success
  #   end
  # end
  
  # describe "CHECKOUT" do
  #   it "can go to checkout page" do
  #     get checkout_path
  #     must_respond_with :success
  #   end
  
  # end
  
end