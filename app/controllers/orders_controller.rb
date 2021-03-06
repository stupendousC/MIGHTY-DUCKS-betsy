class OrdersController < ApplicationController
  
  before_action :find_order, except: [:index, :order_confirmation, :order_summary]
  
  def index
    if session[:merchant_id]
      # for merchants' eyes only
      # sending only the relevant order_items and orders 
      @order_items = OrderItem.by_merchant(session[:merchant_id])
      @orders = @order_items.map { |order_item| order_item.order }
      @orders.uniq!
      
      
      # if merchant wants to FILTER BY ORDER STATUS
      @statuses = %w[ALL SHIPPED PAID PENDING]
      if params[:status_selected]
        statuses_index = params[:status_selected].to_i
        
        # @orders and @order_items will get filtered depending on status selected
        @database_status = @statuses[statuses_index].downcase
        if @database_status == "all"
          # leave @order_items as is
          return
        else
          @order_items = @order_items.find_all { |order_item| order_item.status == @database_status }
          @orders = @order_items.map { |order_item| order_item.order }
          @orders.uniq!
        end
      else
        # if no status dragdown selected, default is "all"
        @database_status = "all"
      end
      
      # if merchant wants a CUSTOMER SPOTLIGHT
      if params[:order_item_id]
        order_item = OrderItem.find_by(id: params[:order_item_id])
        
        unless order_item
          flash[:error] = "That order item doesn't even exist"
          return redirect_to orders_path
        end
        
        if order_item.product.merchant.id == session[:merchant_id]
          @order_item = OrderItem.find_by(id: params[:order_item_id].to_i)
          @order = @order_item.order
          @spotlight_customer = @order.customer
        else
          flash[:error] = "Can't show you customer info for an order item that you don't own"
          return redirect_to orders_path
        end
      end
      
    else
      flash[:error] = "You must be logged in as a merchant"
      return redirect_to root_path
    end
    
  end
  
  
  def show
    # basically a VIEW_CART
    # only way to see this page is if you put stuff in your shopping cart
    # b/c that's when a session[:order_id] is given,
    # and that's the key to unlocking this page via @order from before_action find_order()
    
    if params[:id].to_i <= 0
      # if someone entered in bogus order id, like -5000
      flash[:error] = "That order does not exist"
      return redirect_to root_path
    elsif @order.nil?
      # if someone tries to access someone else's cart or a deleted cart
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
    if session[:order_id]
      @order = Order.new(order_params)
    else
      @order = Order.new
      session[:order_id] = @order.id
    end
    
    if @order.save
      # sets the session order id
      session[:order_id] = @order.id
      flash[:success] = "Successfully created order"
      return redirect_to order_path(@order.id)
    else
      flash[:error] = "Could not create order"
      return redirect_to root_path
    end
  end
  
  # placeholder method
  def edit; end
  
  def update
    if @order.update( order_params )
      # successfully updates order
      @order.order_items.update(qty: params[:order][:quantity])
      flash[:success] = "Successfully updated order"
      return redirect_to root_path
    else
      flash[:error] = "Could not update order"
      return redirect_to order_path(@order.id)
    end
  end
  
  def checkout
    
    if @order
      # sending to page for customer to fill out cc info & such
      @customer = Customer.new
      
      # check one more time that quantities ordered are still available,
      # in case customer stayed on the show page for too long, before clicking checkout
      if @order.missing_stock
        flash[:error] = "Uh oh! We ran out of stock on..."
        flash[:error_msgs] = @order.names_from_order_items(@order.missing_stock)
        return redirect_to order_path(@order)
      end
      
      # if started a cart but emptied out later
      if (@order.order_items == []) || !(@order.order_items)
        flash[:error] = "Please actually buy something before you give us your credit card"
        return redirect_to root_path
      end
      
      # if you're trying to pay for a closed order
      if @order.status != "pending"
        flash[:error] = "Checkout unavailable for that order"
        return redirect_to root_path
      end
    else
      # If not even having a cart to begin with
      flash[:error] = "You don't have anything in a shopping cart"
      return redirect_to root_path
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
          return redirect_to order_path(@order)
        end
      end
      
      # save Order info and switch statuses to "paid"
      @order.update(status: "paid", customer_id: @customer.id)
      @order.order_items.each do |item|
        item.update(status: "paid")
      end
      session[:order_id] = nil
      
      flash[:success] = "Successfully placed order!"
      add_confirmed_order_id_to_session(@order.id) 
      return redirect_to orders_confirmation_path(@order.id)
      
    else
      # invalid payment info given
      flash.now[:error] = "Could not place order"
      flash.now[:error_msgs] = @customer.errors.full_messages
      render action: "checkout"
    end
  end
  
  def order_confirmation
    if session[:order_confirmed]
      if session[:order_confirmed] == params[:id].to_i
        @order = Order.find_by(id: session[:order_confirmed])
        unless @order.status == "paid"
          flash[:error] = "You haven't completed the order yet"
          return redirect_to order_path(id: @order.id)
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
    return redirect_to root_path
  end
  
  
  def status_ship
    # merchant clicked on "ship it!" button in dashboard
    # we'll flip Order instance's status to "shipped"
    # return to same page
    order_item_id = params[:id].to_i
    order_item = OrderItem.find_by(id: order_item_id)
    if order_item
      if order_item.status == "paid"
        order_item.update(status: "shipped")
        flash[:success] = "Order Item ##{order_item.id} status set to 'Shipped'"
        return redirect_to merchant_orders_path(merchant_id: session[:merchant_id])
      end
    else
      flash[:error] = "Order not found"
      return redirect_to merchant_orders_path(merchant_id: session[:merchant_id])
    end
    
  end
  
  private
  def find_order
    @order = Order.find_by(id: session[:order_id])
    if @order.nil?
      @order = Order.find_by(id: params[:id])
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
