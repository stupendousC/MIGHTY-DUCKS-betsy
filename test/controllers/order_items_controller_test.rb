require "test_helper"

describe OrderItemsController do
  
  before do 
    @order = Order.find_by(grand_total: 111111)
    @product = Product.find_by(name: "product2")
    @order_item = OrderItem.create(product_id: @product.id)
  end
  
  describe "create" do
    it "can create an Order Item with a new Order" do
      params = {
        product_id: @product.id
      }
      item = OrderItem.create(params)
      
      expect(item.product_id).must_equal @product.id
      expect(item.qty).must_equal 1
    end
    
    it "can create an Order Item in a current Order" do
    end
    
    it "can calculate the subtotal" do
      expect(@order_item.subtotal).must_be_instance_of Integer
      
      expect(@order_item.qty).must_equal 1
      
      expect(@order_item.subtotal).must_equal @product.price
    end
    
  end
  
  it "can be updated with an order item" do
    patch order_path(@order.id), params: {order: { order_items: [@order_item]}}
    @order.reload
    
    expect(@order.order_items.first).must_equal @order_item
  end
  
  it "can be updated with another order item when one already exists" do
    order_item = OrderItem.create(order_id: @order.id, product_id: @product.id)
    
    
    patch order_path(@order.id), params: {order: { order_items: [order_item]}}
    @order.reload
    
    expect(@order.order_items.length).must_equal 2
    expect(@order.order_items.last).must_equal order_item
  end
  
end