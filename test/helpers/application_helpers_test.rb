require "test_helper"

describe ApplicationHelper, :helper do
  
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
end
