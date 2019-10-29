class OrdersController < ApplicationController
  
  before_action :find_order
  
  def index
    @orders = Order.all
  end
  
  # placeholder method
  def show; end
  
  def new
    @order = Order.new( order_params )
  end
  
  def create
    @order = Order.new( order_params )
    if @order.save
      # sets the session order id
      session[:order_id] = @order.id
      flash[:success] = "Successfully created order"
      redirect_to order_path(@order.id)
    else
      flash[:error] = "Could not create order"
      redirect_to root_path
    end
  end
  
  # placeholder method
  def edit; end
  
  def update
    if @order.update( order_params )
      if @order.order_items.length == 0
        # sets session to nil if there are no products in the order
        session[:order_id] = nil
        flash[:success] = "Order cancelled: all items removed from cart"
        redirect_to orders_path
      else
        # successfully updates order
        @order.order_items.update(qty: params[:order][:quantity])
        flash[:success] = "Successfully updated order"
        redirect_to order_path(@order.id)
      end
    else
      flash[:error] = "Could not update order"
      redirect_to orders_path
    end
  end
  
  def view_cart
    # this is for the view_cart_path
    # possibly make this the same as edit? -kk
    ### Check if qtys on order are still valid? before getting sent to payment/checkout page
  end
  
  def checkout
    # sending to page for customer to fill out cc info & such
  end
  
  def purchase
    # customer fills out cc info @ checkout and gets sent here
    
    # get info from customer input, apply to @order
    @customer_info = params[:order]
    
    @order.name = @customer_info[:name]
    @order.email = @customer_info[:email]
    @order.address = @customer_info[:address]
    @order.city = @customer_info[:city]
    @order.state = params[:state]
    @order.zip = @customer_info[:zip]
    
    if params[:cc_name_same?]
      @order.cc_name = @customer_info[:name]
    else
      @order.cc_name = @customer_info[:cc_name]
    end
    
    @order.cc = @customer_info[:cc]
    @order.cvv = @customer_info[:cvv]
    @order.cc_company = params[:cc_company]
    
    if params[:month] && params[:year]
      @order.cc_exp = params[:month] + " " + params[:year]
    end
    
    @order.customer_info_valid?
    
    raise
    # save Order info and switch status to "done"
    
    # update product inventories
    
    
    
    if @customer_info.valid?
      @order.status = :paid
      session[:order_id] = nil
      flash[:success] = "Successfully placed order!"
      redirect_to order_path(@order.id)
    else
      flash[:error] = "Could not place order"
      redirect_to order_path(@order.id)
    end
  end
  
  def destroy
    @order.delete
    flash[:success] = "Successfully deleted order"
    redirect_to root_path
  end
  
  private
  
  def find_order
    @order = Order.find_by(id: session[:order_id])
    if @order.nil?
      session[:order_id] = nil
    end
  end
  
  def order_params
    return params.require(:order).permit(:order_items, :grand_total)
  end
  
end
