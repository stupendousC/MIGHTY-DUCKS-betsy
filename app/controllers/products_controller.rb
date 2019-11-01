class ProductsController < ApplicationController
  
  before_action :require_login, only: [:new, :create, :edit, :update]
  before_action :require_product_ownership, only: [:edit, :update]
  
  def index 
    @products = Product.where(status: "Available")
    @products_by_merchant = Product.by_merchant(params[:merchant_id])
  end
  
  def show
    product_id = params[:id]
    @product = Product.find_by(id: product_id)

    if @product.nil?
      flash[:error] = "Sorry! That products doesn't exist."
      redirect_to root_path
      return
    end

    @merchant = Merchant.find(@product.merchant_id )
  end
  
  def new
    @product = Product.new
  end
  
  def create 
    @status = "Available"
    @product = Product.new(product_params)
    
    @product.merchant_id = session[:merchant_id]
    
    if @product.save 
      flash[:success] = "#{@product.name} added successfully"
      redirect_to product_path(@product.id)
      return
    else
      @error = @product.errors.full_messages
      flash.now[:error] = "Error: #{@error}"
      render action: "new"
      return
    end
  end
  
  def edit
    @product = Product.find_by(id: params[:id])
    render_404 unless @product
  end
  
  def update
    @status = params[:product][:status]
    
    if @product.update(product_params)
      flash[:success] = "You successfully updated #{@product.name}"
      redirect_to merchant_path(@merchant)
    else
      flash[:error] = "Unable to update #{@product.name}"
      flash[:error_msgs] = @product.error.full_messages
      render edit_product_path
      return
    end
  end
  
  private
  
  def require_login
    @merchant = Merchant.find_by(id: session[:merchant_id])

    if @merchant.nil?
      flash[:error] = "Please log-in first"
      return redirect_to root_path
    end
  end

  def require_product_ownership
    @product = Product.find_by(id: params[:id])
    # this confirms that the product belongs to its merchant
    
    if @product.nil? || @product.merchant.id != @merchant.id
      flash[:error] = "You are not authorized to edit this product!"
      redirect_to root_path
      return
    end
  end
  
  def product_params
    return params.require(:product).permit(:name, :price, :stock, :img_url, :description, category_ids: []).merge(status: @status)
  end
end