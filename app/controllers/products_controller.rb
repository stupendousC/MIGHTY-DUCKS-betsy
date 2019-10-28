class ProductsController < ApplicationController
  
  # I added #new and #create b/c regular guests shouldn't be allowed to add new inventory -CW
  before_action :require_login, only: [:new, :create, :edit, :update]
  before_action :require_product_ownership, only: [:edit, :update]
  
  def index 
    @products = Product.where(status: "Available")
  end
  
  def show
    product_id = params[:id]
    @product = Product.find_by(id: product_id)
    
    if @product.nil?
      # added flash msg so people know why -CW
      flash[:error] = "Sorry, that product does not currently exist"
      redirect_to root_path
      return
    end
  end
  
  def new
    @product = Product.new
  end
  
  def create 
    @status = "Available"
    @product = Product.new( product_params)
    
    
    @product.merchant_id = session[:merchant_id]
    
    if @product.save 
      flash[:success] = "#{@product.name} added successfully"
      redirect_to product_path(@product.id)
      return
    else
      # refactor so that message will print out nicely instead of with brackets
      @error = @product.errors.messages[:name]
      flash.now[:error] = "Error: #{@error}"
      # render new_product_path     #commented out b/c crashed -CW
      render action: "new"
      return
    end
  end
  
  def edit
    # @product = Product.find_by(id: params[:id]) #commented out b/c u already did it in before_action
  end
  
  def update
    # @product = Product.find_by(id: params[:id]) #commented out b/c u already did it in before_action
    
    @status = params[:product][:status]
    
    if @product.update( product_params )
      
      flash[:success] = "You successfully updated #{@product.name}"
      return redirect_to product_path(@product.id)
    else
      # render edit_product_path
      # also added flash msgs -CW
      flash[:error] = "Unable to update #{@product.name}"
      flash[:error_msgs] = @product.error.full_messages
      render action: "edit"
      return
    end
  end
  
  private
  ### I separated require_login into 2 diff methods b/c SRP -CW
  
  def require_login
    @merchant = Merchant.find_by(id: session[:merchant_id])
    
    # what if merchant forgot to login? -CW
    if @merchant.nil?
      flash[:error] = "Please log into your merchant account first"
      return redirect_to root_path
    end
  end
  
  def require_product_ownership
    # call this AFTER require_login, in the before_action
    @product = Product.find_by(id: params[:id])
    
    # need to confirm that the product belongs to its merchant
    unless @product.merchant.id == @merchant.id
      flash[:error] = "You are not authorized to edit this product!"
      # I think u need to render or redirect here, otherwise flash error shows up AFTER u leavet hsi page - CW
      return redirect_to root_path
    end
  end  
  
  def product_params
    return params.require(:product).permit(:name, :price, :stock, :img_url, :description, category_ids: []).merge(status: @status)
  end
end