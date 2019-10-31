require "test_helper"

describe ApplicationHelper, :helper do
  let(:oi1) { order_items(:oi1) }
  let(:oi3) { order_items(:oi3) }
  let(:o1) { orders(:o1) }
  let(:o2) { orders(:o2) }
  let(:oi6) { order_items(:oi6) }
  let(:c1) { customers(:c1) }
  let(:c2) { customers(:c2) }
  
  describe "does display_date() work?" do
    it "nominal" do
      xmas = Date.parse("26-12-2019")
      assert(display_date(xmas) == "Dec 26, 2019")
    end
    
    it "edge" do
      assert(display_date("garbage") == "INVALID DATE")
    end
  end
  
  describe "does usd() work?" do
    it "nominal" do
      assert(usd(1000) == "$10.00")
      assert(usd(99) == "$0.99")
      assert(usd(1) == "$0.01")
    end
    
    it "edge" do
      assert(usd("garbage") == "INVALID INTEGER")
      assert(usd(1.23) == "INVALID INTEGER")
    end
  end
  
  describe "does get_string_of_names() work?" do
    it "nominal" do
      ada = merchants(:ada)
      grace = merchants(:grace)
      assert(get_string_of_names([ada, grace]) == "Countess_ada, Graceful_hopps")
      assert (get_string_of_names([ada]) == "Countess_ada")
    end
    
    it "edge" do
      expect(get_string_of_names([])).must_equal "None"
      
      bad_args = [nil, "garbage", 123]
      bad_args.each do |bad|
        expect(get_string_of_names(bad)).must_equal "Invalid collection"
      end
    end
  end
  
  describe "does first_x_chars() work?" do
    it "nominal" do
      assert(first_x_chars("A") == "A")
      assert(first_x_chars("ABC") == "ABC")
      assert(first_x_chars("ABCDE", 3) == "ABC...")
      assert(first_x_chars("ABCDEFG") == "ABCDE...")
    end
    
    it "edge" do
      bad_args = [nil,[], 123]
      bad_args.each do |bad|
        assert(first_x_chars(bad) == "INVALID")
      end
    end
  end
  
  describe "does make_thumbnail_link() work?" do
    it "nominal" do
      p1 = products(:p1)
      expected = "<a href=\"/products/1060662067\"><img alt=\"picture of product1\" class=\"thumbnail\" src=\"https://live.staticflickr.com/4081/4906646028_1be7b70d6d_z.jpg\" /></a>"
      assert(make_thumbnail_link(p1) == expected)
    end
    
    it "edge" do
      assert(make_thumbnail_link("garbage") == "INVALID")
      assert(make_thumbnail_link(Product.new()) == "NO IMG AVAILABLE")
    end
  end
  
  describe "does customer_from_order_item() work?" do
    it "nominal" do
      puts "Caroline puts false on purpose"
      assert(false)
    end
    
    it "edge" do
      puts "Caroline puts false on purpose"
      assert(false)
    end
  end
  
  describe "does customer_name(order_item) work?" do
    it "If order pending, get pending statement" do
      expect(customer_name(oi1)).must_equal "Pending customer input"
    end
    
    it "If order paid, can get customer name" do
      expect(customer_name(oi6)).must_equal c2.name.capitalize
    end
    
    it "If order shipped, can get customer name" do
      expect(customer_name(oi3)).must_equal c1.name.capitalize
    end
    
    it "If bogus input, return Invalid statement" do
      expect(customer_name("garbage")).must_equal "Invalid order_item instance"
    end
  end
  
  describe "does order_status() work?" do
    it "nominal" do
    end
    
    it "edge" do
    end
  end
  
  describe "does total_price_of_array() work?" do
    it "nominal" do
    end
    
    it "edge" do
    end
  end
end
