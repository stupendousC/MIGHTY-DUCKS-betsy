require "test_helper"

describe Order do
  
  let(:o1) { orders(:o1) }
  let(:oi1) { order_items(:oi1) }
  let(:oi2) { order_items(:oi2) }
  let(:p1) { products(:p1) }
  let(:p2) { products(:p2) }
  
  describe "KELSEY: get_grand_total()" do
    it "nominal" do
    end
    
    it "edge" do
    end
  end
  
  describe "CAROLINE: missing_stock()" do
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
    
    it "if order has no items, what does missing_stock() return?" do 
      
    end
  end
  
  describe "CAROLINE: names_from_order_items()" do
    it "nominal" do
    end
    
    it "edge" do
    end
  end
  
end
