class ApplicationController < ActionController::Base
  before_action :find_order
  before_action :category_index
  
  def find_order
    @order = Order.find_by(id: session[:order_id])
  end
  
  def category_index
    @categories = Category.all
  end
  

  
end
