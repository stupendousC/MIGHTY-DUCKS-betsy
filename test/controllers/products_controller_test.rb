require "test_helper"

describe ProductsController do

  describe "#index action" do
    it "responds with success when there is at least one Product saved" do
      new_product = products(:p1)

      get products_path
      
      must_respond_with :success
      expect(Product.count).must_be :>, 0
    end
    
    it "responds with success when there are products to show " do
      get products_path
      
      must_respond_with :success
      expect(Product.count).must_equal 4
    end
  end
  
  describe "#show action" do
    it "responds with success when showing an existing valid product" do
      new_product = products(:p1)
      get product_path(new_product.id)

      must_respond_with :success
      expect(Product.count).must_be :>, 0
    end
    
    it "responds with 404 with an invalid product id" do
      get product_path(-2000)

      assert(flash[:error] == "Sorry! That products doesn't exist.")
    end
  end

  describe  "guests can" do
    describe "#new action" do
      it "responds with redirect" do
        get new_product_path
        
        must_redirect_to root_path
        assert(flash[:error] = "You must log-in first")
      end
    end

    describe "#create action" do
      it "responds with redirect" do
      get products_path

      must_redirect_to root_path
      assert(flash[:error] = "You must log-in first")
      end
    
      it "will not create new product by not-logged-in user" do
      end
    
  end

  end
end
