class CategoriesController < ApplicationController
  
  before_action :require_login, only: [:new, :create]
  def index; end
  
  def new
    @category = Category.new
  end
  
  def create 
    @category = Category.new(category_params)

    if @category.save
      flash[:success] = "#{@category.name} created successfully!"
      redirect_to new_product_path
      return
    else
      @error = @category.errors.full_messages
      flash.now[:error] = "Error: #{@error}"
      render new_category_path
      return
    end
  end

  def show
    # this would filter by category id selected and show all products that belong to that category
    category_id = params[:id]
    @category = Category.find_by(id: category_id)
    @products = @category.products
  end
  
  private

  def require_login
    @merchant = Merchant.find_by(id: session[:merchant_id])
    
    if @merchant.nil?
      flash[:error] = "Please log-in first!"
      return redirect_to root_path
    end
  end

  def category_params
    return params.require(:category).permit(:name)
  end
end
