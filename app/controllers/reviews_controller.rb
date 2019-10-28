class ReviewsController < ApplicationController
  before_action :cant_be_merchant_product
  
  def new
    @review = Review.new()
  end
  
  def create
    #You have to make sure merchant can't review their own product so use the helper method here. 
    #Would this work or would I have to find the product again so I could use it in if @review
    
    @review = Review.new(review_params)
  
    #You need to go to the form that will allow you to input information.
  
    if @review.save 
      flash[:success] = "#{@product.name}successfully reviewed"
      redirect_to product_path(@product.id)
      return
    else
      # refactor this line of code
      @error = @review.errors.messages[:name]
      flash.now[:error] = "Error: #{@error}"
      render new_review_path
      return
    end
  end
  
  # def edit
  #   #should I combine this like caroline did?
  #   #you will need to go find the correct review and form for the thing you are working on
  #   #if you are a logged in merchant you should not be able to review a product that belongs to you. 
  #   @review = Review.find_by(id: params[:id])
  # end
  
  # def update
  #   #you will be taken to the form for the particular review. 
  #   #You should be given a flash that the review was successfully updated.
  #   #the edit page should be re-edited if the review was not updated. You should be told why it didn't work.
  
  #   if @review.update(review_params)
  #     flash[:success] = "Information was updated"
  
  #     if @merchant.name != session[:merchant_name]
  #       # I want the nav buttons to reflect the new name
  #       session[:merchant_name] = @merchant.name
  #     end
  
  #     redirect_to merchant_path(@merchant.id)
  #     return
  
  #   else
  #     flash.now[:error] = "Unable to update"
  #     flash.now[:error_msgs] = @merchant.errors.full_messages
  #     render action: "edit"
  #     return
  #   end
  # end
  
  
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