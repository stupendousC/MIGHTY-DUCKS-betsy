require "test_helper"

describe CategoriesController do
  
  describe "show" do 
    let(:category) { categories(:c1)}
    it "can get a category by its id" do
      get category_path(category.id)
      must_respond_with :success
      
    end
  end
  

  describe "logged in merchants can" do
    describe "#new action" do
      it "succeeds" do
        get new_category_path

        must_respond_with :found
      end
    end

    describe "#create action" do
      it "can create a new category" do
        @m1 = merchants(:m1)
        perform_login(@m1)

        new_category = {
          category: {
          name: "baby toys" }
        }

        expect {
          post categories_path, params: new_category
        }.must_change "Category.count", 1

        must_redirect_to new_product_path
      end

      it "won't allow a duplicate name" do
        @m1 = merchants(:m1)
        perform_login(@m1)

        new_category = {
          category: {
          name: "Toys" }
        }

        expect {
          post categories_path, params: new_category
        }.wont_change "Category.count"

        must_respond_with :success
        assert(flash.now[:error] = "Error: #{@error}")
      end
    end
  end 
end
