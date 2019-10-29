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
    ## CW's
    if session[:order_id]
      @order = Order.new(order_params)
    else
      @order = Order.create
      session[:order_id] = @order.id
    end
    
    
    ## KELSEY's
    # @order = Order.new( order_params )
    
    
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
    @customer = Customer.new
  end
  
  def purchase
    # customer fills out cc info @ checkout and gets sent here
    
    @customer= Customer.new(customer_params)
    
    # these has to be entered manually b/c they came from outside params[:customer]
    @customer.state = params[:state]
    if params[:cc_name_same?] == "true"
      @customer.cc_name = @customer.name
    end
    @customer.cc_company = params[:cc_company]
    @customer.cc_exp_month = params[:month] 
    @customer.cc_exp_year = params[:year]
    if params[:month] && params[:year]
      @customer.cc_exp = params[:month] + " " + params[:year]
    end
    
    if @customer.save
      # customer info valid, therefore payment successful
      
      # save Order info and switch status to "done"
      @order.status = "paid"
      session[:order_id] = nil
      
      flash[:success] = "Successfully placed order!"
      redirect_to order_path(@order.id)
      
      # update product inventories
      
      ###
      
    else
      flash[:error] = "Could not place order"
      flash[:error_msgs] = @customer.errors.full_messages
      render action: "checkout"
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
  
  def customer_params
    return params.require(:customer).permit(:name, :email, :address, :city, :zip, :cc, :cvv, :cc_name)
  end
  
end
