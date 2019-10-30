require "test_helper"
describe OrderItemsController do
  
  before do 
    @order = Order.find_by(grand_total: 111111)
    @product = Product.find_by(name: "product2")
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
      post order_items_path(@params) 
      
      must_respond_with :redirect
      expect(flash[:success]).must_equal "Item added to order"
      
      item = OrderItem.find_by(product_id: @product.id)
      order_nil = item.order_id.nil?
      refute(order_nil)
      expect(item.product_id).must_equal @product.id
      expect(item.qty).must_equal 2
    end
    
    it "can create an Order Item in a current Order" do
      
      post order_items_path(@params)
      item = OrderItem.find_by(product_id: @product.id)
      
      post order_items_path(@params)
      must_respond_with :redirect
      expect(item.qty).must_equal 2
    end
    
    it "can calculate the subtotal of a created Order Item" do
      post order_items_path(@params)
      item = OrderItem.find_by(product_id: @product.id)
      # item.save calls the private get_subtotal method
      item.save
      
      expect(item.qty).must_equal 2
      expect(item.subtotal).must_equal @product.price * item.qty
      
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
        quantity: 1
      }
      
      patch order_order_item_path(order_id: @item.order_id, id: @item.id), params: item_hash
      
      updated_item = OrderItem.find_by(id: @item.id)
      must_respond_with :redirect
      
      expect(flash[:success]).must_include "update"
      expect(updated_item.qty).must_equal 1
    end
    
    
    
    it "can remove an order item" do
      
      item_hash = { 
        remove: "1"
      }
      
      patch order_order_item_path(order_id: @item.order_id, id: @item.id), params: item_hash
      
      must_respond_with :redirect
      expect(@item).must_equal nil
      
    end
    
    it "will not update qty if requesting greater than in stock" do      
      original_qty = @item.qty
      
      item_hash = {
        order_item: {
          qty: 2001
        }
      }
      patch order_order_item_path(order_id: @item.order_id, id: @item.id), params: item_hash
      
      must_respond_with :redirect
      expect(flash[:error]).must_include "Could not update order"
      expect(@item.qty).must_equal original_qty
    end
    
    it "will not update qty if requesting fewer than 1" do
      original_qty = @item.qty
      
      item_hash = {
        order_item: {
          qty: 0
        }
      }
      patch order_order_item_path(order_id: @item.order_id, id: @item.id), params: item_hash
      
      must_respond_with :redirect
      expect(flash[:error]).must_include "Could not update order"
      expect(@item.qty).must_equal original_qty      
    end
    
  end  
end