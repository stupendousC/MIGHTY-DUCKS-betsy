class OrderItem < ApplicationRecord
  
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
    # put it here?  call this when creating/updating an order_item instance
  end
  
end
