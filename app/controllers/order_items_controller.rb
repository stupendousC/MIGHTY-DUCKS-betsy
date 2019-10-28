class OrderItemsController < ApplicationController
  
  def index
    @order_items = OrderItem.all
  end
  
  def create
    if session[:order_id].nil?
      # creates a new order if one doesn't exist
      @order = Order.create
      @order_id = @order.id
    else
      # uses current order if it exists
      @order_id = session[:order_id]
    end
    if @qty.nil?
      # set qty to 1
      @qty = 1
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
    @order_item = OrderItem.find_by(id: params[:order_id])
    @order = Order.find_by(id: @order_item.order_id)
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
    if params[:qty] < 0
      flash[:error] = "You cannot order fewer than 1"
      redirect_to edit_order_path(@order.id)
    end
    if @order_item.update(qty: params[:quantity])
      flash[:success] = "Successfully updated order"
      redirect_to edit_order_path(@order.id)
    else
      flash[:error] = "Could not update order"
      redirect_to order_path(@order.id)
    end
  end
  
  def destroy; end
  
  
  
  def order_item_params
    
    return params.require(:order_item).permit(:product_id, :subtotal).merge(qty: @qty, order_id: @order_id) 
  end
  
  
end
