class ProductsController < ApplicationController
  
  before_action :require_login, only: [:edit, :update]
  
  def index 
    @products = Product.where(status: "Available")
    @products_by_merchant = Product.by_merchant(params[:merchant_id].to_i)
  
  end
  
  def show
    product_id = params[:id]
    @product = Product.find_by(id: product_id)
    @merchant = Merchant.find(@product.merchant_id )

    if @product.nil?
      redirect_to root_path
      return
    end
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
      render new_product_path
      return
    end
  end
  
  def edit
    @product = Product.find_by(id: params[:id])
  end
  
  def update
    @product = Product.find_by(id: params[:id])
    
    @status = params[:product][:status]
    
    if @product.update( product_params )
      flash[:success] = "You successfully updated #{@product.name}"
      redirect_to merchant_path(@merchant)
    else
      render edit_product_path
      return
    end
  end
  
  private
  
  def require_login
    @merchant = Merchant.find_by(id: session[:merchant_id])
    @product = Product.find_by(id: params[:id])
    
    # this confirms that the product belongs to its merchant
    unless @product.merchant.id == @merchant.id
      flash[:error] = "You are not authorized to edit this product!"
      redirect_to products_path
      return
    end
  end
  
  def product_params
    return params.require(:product).permit(:name, :price, :stock, :img_url, :description, category_ids: []).merge(status: @status)
  end
end