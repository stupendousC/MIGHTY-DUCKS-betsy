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
  
  



  describe "index" do
    it "responds with success when there is at least one Product saved" do
      Product.create(name: "test product", price: 0, stock: 0, img_url: "test_url", description: "test description")
      
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

  describe "show" do
    it "responds with success when showing an existing valid product" do
     

      get product_path(product.id)

      must_respond_with :success
      expect(Product.count).must_be :>, 0
    end
    
    it "responds with 404 with an invalid product id" do
      get product_path(-2000)
      
      must_respond_with Error
    end
  end

  describe "new" do
    it "responds with success" do
      get new_product_path
      
      must_respond_with :success
    end
  end


















end
