require "test_helper"

describe Order do
  
  let(:o1) { orders(:o1) }
  let(:oi1) { order_items(:oi1) }
  let(:oi2) { order_items(:oi2) }
  let(:p1) { products(:p1) }
  let(:p2) { products(:p2) }
  let (:empty_order) { Order.create() }
  
  describe "RELATIONSHIPS" do
    it "can have many order items" do      
      o1.order_items << oi1
      o1.order_items << oi2
      assert(o1.order_items.length > 1)
    end
  end
  
  describe "default status" do
    it "sets the status of an order to 'pending'" do
      o1.status = nil
      o1.default_status
      expect(o1.status).must_equal "pending"
    end
  end
  
  describe "get_grand_total" do
    it "can get the grand total" do
      total = 0
      o1.order_items.each do |item|
        total += item.subtotal
      end
      expect(o1.get_grand_total).must_equal total
    end
    
    it "returns a grand total of 0 for a cart with no items" do
      o1.order_items.destroy_all
      o1.reload
      expect(o1.get_grand_total).must_equal 0
    end
  end
  
  describe "missing_stock()" do
    it "if no missing stock, return nil" do
      expect(o1.missing_stock).must_be_nil
    end
    
    it "if has missing stock, return array of out of stock order_items" do
      o1
      expect(p1.stock).must_equal 5
      expect(p2.stock).must_equal 2
      
      p1.update!(stock: 0)
      p2.update!(stock: 0)
      
      assert(o1.missing_stock)
      assert(o1.missing_stock.length == 2)
      assert(o1.missing_stock.include? oi1)
      assert(o1.missing_stock.include? oi1)
    end
    
    it "if order has no items, missing_stock() returns nil" do 
      expect(empty_order.missing_stock).must_be_nil
    end
  end
  
  describe "names_from_order_items()" do
    it "Can return string of order_item's product names" do
      expect(o1.names_from_order_items([oi1, oi2])).must_equal "Product1, Product2"
      expect(o1.names_from_order_items([oi1])).must_equal "Product1"
    end
    
    it "If order has 0 order_items, returns 'None'" do
      expect(empty_order.names_from_order_items([])).must_equal "None"
    end
    
    it "If bogus argument used, returns expected error statement" do
      expect(o1.names_from_order_items("garbage")).must_equal "Invalid argument, expecting an array of Order Item instances"
    end
  end
  
end
