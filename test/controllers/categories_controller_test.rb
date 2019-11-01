require "test_helper"

describe CategoriesController do
  
  describe "show" do 
    let(:category) { categories(:c1)}
    it "can get a category by its id" do
      get category_path(category.id)
      must_respond_with :success
      
    end
  end
  
end
