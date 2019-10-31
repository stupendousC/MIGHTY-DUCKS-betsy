require "test_helper"
describe OrderItemsController do
  
  before do 
    @order = Order.find_by(grand_total: 111111)
    @product = Product.find_by(name: "orderitemtestproduct")
    @order_item = OrderItem.create(product_id: @product.id)
  end
  
  describe "create" do
    before do 
      @params = {
        order_item: {
          product_id: @product.id
        }
      }
    end
    
    it "can create an Order Item with a new Order" do      
      # assert that new Order is created
      expect{post order_items_path(@params)}.must_differ "Order.count", 1      
      # assert that there is only one Order Item for that product
      expect(OrderItem.where(product_id: @product.id).length).must_equal 1
      
      must_respond_with :redirect
      expect(flash[:success]).must_equal "Item added to order"
      
      item = OrderItem.find_by(product_id: @product.id)
      order_nil = item.order_id.nil?
      refute(order_nil)
      expect(item.product_id).must_equal @product.id
      expect(item.qty).must_equal 1
    end
    
    it "can create an Order Item in a current Order" do
      # creates a new Order session so that order_items_path won't create a new Order session
      expect{post orders_path}.must_differ "Order.count", 1
      
      # ensure that Order Item is not creating a new Order
      expect{post order_items_path(@params)}.must_differ "Order.count", 0
      item = OrderItem.find_by(product_id: @product.id)
      
      must_respond_with :redirect
      expect(item.qty).must_equal 1
      expect(item.order_id).must_equal Order.last.id
    end
    
    it "can update the quantity of a current Order Item" do
      expect{post order_items_path(@params)}.must_differ "OrderItem.count", 1
      expect{post order_items_path(@params)}.must_differ "OrderItem.count", 0
      must_respond_with :redirect
      expect(flash[:success]).must_equal "Successfully updated order item"      
    end
    
    it "can calculate the subtotal of a created Order Item" do
      post order_items_path(@params)
      item = OrderItem.find_by(product_id: @product.id)
      # item.save calls the private get_subtotal method
      item.save
      
      expect(item.qty).must_equal 1
      expect(item.subtotal).must_equal @product.price * item.qty
    end
    
    it "will not create an Order Item if product stock is less than 1" do
      @product.update(stock: 0)
      
      expect{ post order_items_path(@params) }.must_differ "OrderItem.count", 0
      must_respond_with :redirect
    end
    
    it "will not create an Order Item if product status is unavailable" do
      @product.update(status: "Unavailable")
      
      expect{ post order_items_path(@params) }.must_differ "OrderItem.count", 0
      must_respond_with :redirect
    end
    
    it "will not create an Order Item with an invalid Product Id" do
      @params = {
        order_item: {
          product_id: "badid"
        }
      }
      expect{post order_items_path(@params)}.must_raise NoMethodError
    end    
  end
  
  describe "update" do
    before do 
      @params = {
        order_item: {
          product_id: @product.id
        }
      }
      post order_items_path(@params)
      @item = OrderItem.find_by(product_id: @product.id)
    end
    
    it "can update qty of an order item" do
      item_hash = {
        quantity: 2
      }
      
      expect(@item.qty).must_equal 1
      patch order_order_item_path(order_id: @item.order_id, id: @item.id), params: item_hash
      
      updated_item = OrderItem.find_by(id: @item.id)
      must_respond_with :redirect
      
      expect(flash[:success]).must_include "update"
      expect(updated_item.qty).must_equal 2
    end
    
    it "can remove an order item" do
      item_hash = { 
        remove: 1
      }
      
      expect{patch order_order_item_path(order_id: @item.order_id, id: @item.id), params: item_hash}.must_differ "OrderItem.count", -1
      
      must_respond_with :redirect
      expect(flash[:success]).must_include "removed"
    end
    
    it "will redirect if trying to remove an order item that does not exist" do
      item_hash = {
        remove: 1
      }
      
      expect{patch order_order_item_path(order_id: @item.order_id, id: 999), params: item_hash}.must_differ "OrderItem.count", 0
      must_respond_with :redirect
      expect(flash[:error]).must_include "does not exist"
    end
    
    it "will not update qty if requesting greater than in stock" do      
      original_qty = @item.qty
      item_hash = {
        quantity: "2222"
      }
      
      patch order_order_item_path(order_id: @item.order_id, id: @item.id), params: item_hash
      
      must_respond_with :redirect
      expect(flash[:error]).must_include "Could not update order"
      expect(@item.qty).must_equal original_qty
    end
    
    it "will not update qty if requesting fewer than 1" do
      original_qty = @item.qty
      
      item_hash = {
        quantity: "-10"
      }
      
      patch order_order_item_path(order_id: @item.order_id, id: @item.id), params: item_hash
      
      must_respond_with :redirect
      expect(flash[:error]).must_include "You cannot order fewer than 1"
      expect(@item.qty).must_equal original_qty      
    end
    
  end  
end