class OrderItemsController < ApplicationController
  
  def index
    @order_items = OrderItem.all
  end
  
  def create
    order_item = OrderItem.new(product_id: params[product.id], order_id: session[:order_id], qty: 1, subtotal: params[product.price])
    if order_item.save
      flash[:success] = "Item added to order"  
      redirect_to product_path(params[product.id])
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
    if @order_item.update(qty: params[:quantity])
      flash[:success] = "Successfully updated order"
      redirect_to edit_order_path(@order.id)
    else
      flash[:error] = "Could not update order"
      redirect_to order_path(@order.id)
    end
  end
  
  def destroy; end
  
end
