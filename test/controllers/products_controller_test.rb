# require "test_helper"
# require "pry"
# describe ProductsController do

#   describe "#index action" do
#   it "responds with success when there is at least one Product saved" do
#     new_product = products(:p1)

#     get products_path

#     must_respond_with :success
#     expect(Product.count).must_be :>, 0
#     it "responds with success when there are products to show " do
#       get products_path

#       must_respond_with :success
#       expect(Product.count).must_equal 5
#     end
#   end

#   it "responds with success when there are products to show " do
#     get products_path

#     must_respond_with :success
#     expect(Product.count).must_equal 5
#   end
# end

# describe "#show action" do
# it "responds with success when showing an existing valid product" do
#   new_product = products(:p1)
#   get product_path(new_product.id)

#   must_respond_with :success
#   expect(Product.count).must_be :>, 0
# end

# describe "logged-in merchants can" do
#   let(:existing_product) {products(:p1)}

#   before do
#     @m1 = merchants(:m1)
#     perform_login(@m1)
#   end

#   describe "#new action" do
#   it "creates a new product with valid category data" do
#     m1 = merchants(:m1)
#     perform_login(m1)

#     new_product = { 
#     product: {
#     name: "name",
#     price: 2000,
#     stock: 20,
#     merchant_id: m1.id
#   }
# }

# expect {
# post products_path, params: new_product
# }.must_change "Product.count", 1

# it "responds with 404 with an invalid product id" do
#   get product_path(-2000)

#   assert(flash[:error] == "Sorry! That products doesn't exist.")
# end
# end


# describe "logged-in merchants can" do
#   let(:existing_product) {products(:p1)}

#   before do
#     @m1 = merchants(:m1)
#     perform_login(@m1)
#   end

#   describe "#new action" do
#   it "creates a new product with valid category data" do
#     m1 = merchants(:m1)
#     perform_login(m1)

#     new_product = { 
#     product: {
#     name: "name",
#     price: 2000,
#     stock: 20,
#     merchant_id: m1.id
#   }
# }

# expect {
# post products_path, params: new_product
# }.must_change "Product.count", 1

# new_product_id = Product.find_by(name: "name").id

# must_respond_with :redirect
# must_redirect_to product_path(new_product_id)
# end
# end
# describe "#edit action" do
# it "responds with success for an existing product id" do
#   @merchant = @m1

#   get edit_product_path(existing_product.id)

#   describe "#edit action" do
#   it "responds with success for an existing product id" do
#     @merchant = @m1

#     get edit_product_path(existing_product.id)

#     must_respond_with :success
#   end

#   it "FAIL responds with 404 for an invalid product id" do
#     @merchant = @m1

#     get edit_product_path(-200)

#     must_respond_with :not_found
#   end
# end
# it "FAIL responds with 404 for an invalid product id" do
#   @merchant = @m1

#   describe "#update action" do
#   it "can successfully update data on a valid product" do
#     # @m1 = merchants(:m1)
#     # perform_login(@m1)
#     @merchant = @m1

#     updates = { product: { price: 5000 } }

#     expect {
#     put product_path(existing_product), params: updates
#   }.wont_change "Product.count"

#   updated_product = Product.find_by(id: existing_product.id)
#   # p updated_product.attributes
#   # p existing_product.attributes
#   # p flash

#   updated_product.price.must_equal 5000
#   must_respond_with :redirect
#   must_redirect_to merchant_path(id: @merchant.id)

# end

# it "doesn't update the product info when data is invalid" do
#   skip
# end
# end
# end #logged-in merchants describe

# describe  "GUESTS can" do
#   describe "#new action" do
#   it "FAIL will not allow and responds with redirect" do
#     get new_product_path

#     must_redirect_to root_path
#     assert(flash[:error] = "You must log-in first")
#     describe "#update action" do
#     it "can successfully update data on a valid product" do
#       # @m1 = merchants(:m1)
#       # perform_login(@m1)
#       @merchant = @m1

#       updates = { product: { price: 5000 } }

#       expect {
#       put product_path(existing_product), params: updates
#     }.wont_change "Product.count"

#     updated_product = Product.find_by(id: existing_product.id)
#     # p updated_product.attributes
#     # p existing_product.attributes
#     # p flash

#     updated_product.price.must_equal 5000
#     must_respond_with :redirect
#     must_redirect_to merchant_path(id: @merchant.id)

#   end

#   it "doesn't update the product info when data is invalid" do
#     skip
#   end
# end
# end #logged-in merchants describe

# describe  "GUESTS can" do
#   describe "#new action" do
#   it "FAIL will not allow and responds with redirect" do
#     get new_product_path

#     must_redirect_to root_path
#     assert(flash[:error] = "You must log-in first")
#   end
# end

# describe "#create action" do
# it "will not allow and responds with redirect" do
#   get products_path

#   # must_redirect_to root_path
#   assert(flash[:error] = "You must log-in first")
# end
# end
# end
# end

# describe "#create action" do
# it "will not allow and responds with redirect" do
#   get products_path

#   # must_redirect_to root_path
#   assert(flash[:error] = "You must log-in first")
# end
# end
# end


# end