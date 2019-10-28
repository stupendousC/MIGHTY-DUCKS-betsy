require "test_helper"

describe ProductsController do
  
  describe "index/show" do
    it "can show product#index page" do
      get products_path
      must_respond_with :success
    end
    
    it "can retrieve products by category" do
      @product = Product.last
      @categories = @product.categories

      get categories_path(@categories.first.id)
      must_respond_with :success
      
    end
    
    it "can retrieve products by merchant" do
      
    end
    
    it "can retrieve details about a product" do
    end
    
  end
  
  describe "create" do
    it "can create new product by logged in merchant" do
      @merchant = Merchant.first
      perform_login(@merchant)

      
    end
    
    it "will not create new product by not-logged-in user" do
    end
    
  end
  
  
end
