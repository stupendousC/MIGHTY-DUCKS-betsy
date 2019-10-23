class ProductsController < ApplicationController

  before_action :require_user, only: [:new, :create, :edit, :update]

  def index 
    @products = Product.all
    # in product index view page, we only want to show products where status = nil
  end

  def show
    product_id = params[:id]
    @product = Product.find_by(id: product_id)

    if @product.nil?
      redirect_to root_path
      return
    end
  end

  def new
    @product = Product.new
  end

  def create 
    @product = Product.new( product_params )

    if @product.save 
      flash[:success] = "#{@product.name} added successfully"
      redirect_to product_path(@product.id)
      return
    else
      # refactor so that message will print out nicely instead of with brackets
      @error = @product.errors.messages[:name]
      flash.now[:error] = "Error: #{@error}"
      render new_product_path
      return
    end
  end

  def edit
    @product = Product.find_by(id: params[:id])
  end

  def update
    @product = Product.find_by(id: params[:id])

    if @product.update( product_params )
      flash[:success] = "You successfully updated #{@product.name}"
      redirect_to product_path(@product.id)
    else
      render edit_product_path
      return
    end
  end

  private

  def require_login
    @merchant = Merchant.find_by(id: session)
    if @merchant.nil?
      flash[:error] = "You must log in first!"
      redirect_to root_path
    end
  end

  def product_params
    return params.require(:product).permit(:name, :price, :stock, :img_url, :description, :status)
  end
end
