class OrdersController < ApplicationController
  
  before_action :find_order, except: [:index, :order_confirmation]
  
  def index
    if session[:merchant_id]
      # sending only the relevant order_items and orders 
      @order_items = OrderItem.by_merchant(session[:merchant_id])
      @orders = @order_items.map { |order_item| order_item.order }
      @orders.uniq!
    else
      flash[:error] = "You must be logged in as a merchant"
      return redirect_to root_path
    end
  end
  
  
  def show
    if params[:id].to_i <= 0
      # if someone entered in bogus order id, like -5000
      flash[:error] = "That order does not exist"
      return redirect_to root_path
    elsif @order.nil?
      # if someone tries to access someone else's cart
      flash[:error] = "Sorry, that order is unavailable for viewing"
      return redirect_to root_path
    end
    
    if @order.missing_stock
      flash.now[:error] = "Uh oh! We ran out of stock on..."
      flash.now[:error_msgs] = @order.names_from_order_items(@order.missing_stock)
    end
  end
  
  def new
    @order = Order.new( order_params )
  end
  
  def create
    # CW's
    if session[:order_id]
      @order = Order.new(order_params)
    else
      @order = Order.new
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
      # successfully updates order
      @order.order_items.update(qty: params[:order][:quantity])
      flash[:success] = "Successfully updated order"
      redirect_to root_path
    else
      flash[:error] = "Could not update order"
      redirect_to order_path(@order.id)
    end
  end
  
  def view_cart
    # this is for the view_cart_path
    # possibly make this the same as edit? -kk  
    ### I AGREE! THIS IS THE SAME AS Order#show, delete I would...
  end
  
  def checkout
    # sending to page for customer to fill out cc info & such
    @customer = Customer.new
    
    # check one more time that quantities ordered are still available,
    # in case customer stayed on the show page for too long, before clicking checkout
    if @order.missing_stock
      flash[:error] = "Uh oh! We ran out of stock on..."
      flash[:error_msgs] = @order.names_from_order_items(@order.missing_stock)
      redirect_to order_path(@order)
    end
    
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
      
      # update product inventories
      @order.order_items.each do |order_item|
        product = order_item.product
        new_stock = product.stock - order_item.qty
        unless product.update(stock: new_stock)
          # someone else is checking out at the same time and beat u to it
          flash[:error] = "Sorry, someone else snatched up all remaining stock of #{product.name}..."
          redirect_to order_path(@order)
        end
      end
      
      # save Order info and switch status to "done"
      @order.update(status: "paid", customer_id: @customer.id)
      session[:order_id] = nil
      
      flash[:success] = "Successfully placed order!"
      add_confirmed_order_id_to_session(@order.id) 
      redirect_to orders_confirmation_path(@order.id)
      
    else
      # invalid payment info given
      flash[:error] = "Could not place order"
      flash[:error_msgs] = @customer.errors.full_messages
      render action: "checkout"
    end
  end
  
  def order_confirmation
    if session[:order_confirmed]
      if session[:order_confirmed] == params[:id].to_i
        @order = Order.find_by(id: session[:order_confirmed])
        unless @order.status == "paid"
          flash[:error] = "You haven't completed the order yet"
          redirect_to order_path(id: @order.id)
        end
      else
        flash[:error] = "That was not your order"
        return redirect_to root_path
      end
      
    else
      flash[:error] = "You're not authorized to see this page"
      return redirect_to root_path
    end
  end
  
  def destroy
    @order.order_items.destroy_all
    @order.delete
    session[:order_id] = nil
    flash[:success] = "Successfully deleted order"
    redirect_to root_path
  end
  
  private
  def find_order
    @order = Order.find_by(id: session[:order_id])
    if @order.nil?
      @order = Order.find_by(id: params[:id])
    end
    if @order.nil?
      session[:order_id] = nil
    end
  end
  
  def order_params
    return params.require(:order).permit(:order_items, :grand_total)
  end
  
  def customer_params
    return params.require(:customer).permit(:name, :email, :address, :city, :zip, :cc1, :cc2, :cc3, :cc4, :cvv, :cc_name)
  end
  
  def add_confirmed_order_id_to_session(order_id)
    session[:order_confirmed] = order_id
    
    ### THIS IS IN CASE CUSTOMER MAKES SEVERAL PURCHASES IN SAME SESSION, BUT IT'S TRICKY...
    # if session[:orderS_confirmed] 
    #   session[:orderS_confirmed] << order_id
    # else
    #   session[:orderS_confirmed] = [order_id]
    # end
  end
  
end
