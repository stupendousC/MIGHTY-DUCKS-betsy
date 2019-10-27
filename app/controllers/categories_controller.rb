class CategoriesController < ApplicationController
  def show
    # this would filter by category id selected and show all products that belong to that category
    category_id = params[:id]
    @category = Category.find_by(id: category_id)
    @products = @category.products
  end
end
