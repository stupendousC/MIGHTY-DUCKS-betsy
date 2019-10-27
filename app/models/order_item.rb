class OrderItem < ApplicationRecord
  before_save :get_subtotal
  before_save :get_order
  before_save :default_qty
  
  belongs_to :product
  belongs_to :order 
  
  # VALIDATIONS:
  # 1.  Must belong to a Product
  # 2.  Must belong to an Order
  # 3.  Quantity must be present
  # 4.  Quantity must be an integer
  # 5.  Quantity must be greater than 0
  
  
  def self.by_merchant(id)
    order_items = OrderItem.all
    result = []
    order_items.each do |item|
      if Product.find_by(id: item.product_id).merchant_id == id
        result << item
      end
    end
    return result
  end
  
  private
  
  def get_subtotal
    product = Product.find_by(id: self.product_id).price
    self.subtotal = self.qty.to_i * product
  end
  
  def get_order
    if self.order_id == nil
      order = Order.create
      order_item.order_id = order.id
    end
  end
  
  def default_qty
    if self.qty == nil
      self.qty = 1
    end
  end
  
end
