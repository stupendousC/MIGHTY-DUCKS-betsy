require "test_helper"

describe OrdersController do
  
  describe "VIEW_CART" do
    it "can go to view_cart page" do
      get view_cart_path
      must_respond_with :success
    end
  end
  
  describe "CHECKOUT" do
    it "can go to checkout page" do
      get checkout_path
      must_respond_with :success
    end
    
  end
  
end