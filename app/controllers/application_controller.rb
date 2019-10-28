class ApplicationController < ActionController::Base
  before_action :find_order
  
  def find_order
    @order = Order.find_by(id: session[:order_id])
  end
  
end
