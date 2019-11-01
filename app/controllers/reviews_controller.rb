class ReviewsController < ApplicationController
  before_action :cant_be_merchant_product
  
  def new
    @review = Review.new()
  end
  
  def create
    @review = Review.new(review_params)
    
    product = Product.find_by(id: params[:product_id])
    
    unless product
      flash[:error] = "product doesn't exist"
      head :bad_request
      redirect_to product_path(product.id)
      #redirect with error
      return
    end
    
    @review.product = product
  
    if @review.save 
      flash[:success] = "#{product.name} successfully reviewed"
      redirect_to product_path(product.id)
      return
    else
      @error = @review.errors.full_messages
      flash[:error] = "#{@error}"
      redirect_to product_path(product.id)
      return
    end
  end

  
private
  def review_params
    return params.require(:review).permit(:rating, :comment)
  end
  
  def cant_be_merchant_product
    if session[:merchant_id]
      @product = Product.find_by(id: params[:product_id])
      
      if @product.merchant.id == session[:merchant_id]
        flash[:error] = "Merchants can't review their own products"
        return redirect_to root_path
      end
    end
  end
end