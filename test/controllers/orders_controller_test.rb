require "test_helper"

describe OrdersController do
  
  describe "create" do
    it "can create an order" do
    end
    
    it "sets the initial status to 'pending'" do
      item = OrderItem.create(product_id: 1)
      order = {
        order: {
          # status: "pending"
          order_items: item
        }
      }
      post orders_path, params: order
      p Order.first
    end
    
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