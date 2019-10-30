class OrderItemsController < ApplicationController
  
  def index
    @order_items = OrderItem.all
  end
  
  def create
    product = Product.find_by(id: params[:order_item][:product_id])
    
    if session[:order_id].nil?
      # creates a new order if one doesn't exist
      @order = Order.create
      @order_id = @order.id
      
      # CW trial: adding here instead
      session[:order_id] = @order_id
    else
      # uses current order if it exists
      @order_id = session[:order_id]
      # @order = Order.find_by(id: session[:order_id])
      current_item = @order.order_items.find_by(product_id: order_item_params[:product_id])
      # checks if item is already in order, updates by 1 if so
      if current_item
        current_item[:qty] += 1
        current_item.save
        flash[:success] = "Successfully updated order item"
        redirect_to product_path(product.id)
        return
      end
    end
    
    if @qty.nil?
      # set qty to 1
      @qty = 1
    end
    
    if product.stock < 1 || product.status == "Unavailable"
      flash[:error] = "Could not add item to order (not enough in stock)"
      redirect_to product_path(product.id)
      return
    end
    
    order_item = OrderItem.new( order_item_params )
    
    if order_item.save
      flash[:success] = "Item added to order"  
      if session[:order_id].nil?
        session[:order_id] = order_item.order_id
      end
      redirect_to product_path(order_item.product_id)
    else
      flash[:error] = "Could not add item to order"
      redirect_to products_path
    end
    
  end
  
  def update
    @order_item = OrderItem.find_by(id: params[:id])
    @product = Product.find_by(id: @order_item.product_id)
    @order = Order.find_by(id: @order_item.order_id)
    
    # removes the item from the order
    if params[:remove] == "1"
      if @order_item.destroy
        flash[:success] = "Successfully removed order item"
        redirect_to edit_order_path(@order.id)
        return
      else 
        flash[:error] = "That order item does not exist"
        redirect_to root_path
        return
      end
    end
    
    # won't let user order fewer than 1 item
    if params[:quantity].to_i < 0
      flash[:error] = "You cannot order fewer than 1"
      redirect_to edit_order_path(@order.id)
      return
      # won't let user order greater than what's in stock
    elsif params[:quantity].to_i > @product.stock.to_i
      flash[:error] = "Could not update order (not enough in stock)"
      redirect_to edit_order_path(@order.id)
      return
    end
    # will let user update qty
    if @order_item.update(qty: params[:quantity])
      flash[:success] = "Successfully updated order item"
      redirect_to edit_order_path(@order.id)
      return
    else
      flash[:error] = "Could not update order"
      redirect_to edit_order_path(@order.id)
      return
    end
  end
  
  def destroy
    session[:order_id] = nil
  end
  
  
  
  def order_item_params
    
    return params.require(:order_item).permit(:product_id, :subtotal).merge(qty: @qty, order_id: @order_id) 
  end
  
  
end
