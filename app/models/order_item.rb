class OrderItem < ApplicationRecord
  
  belongs_to :product
  belongs_to :order 
  
  # VALIDATIONS:
  # 1.  Must belong to a Product
  # 2.  Must belong to an Order
  # 3.  Quantity must be present
  # 4.  Quantity must be an integer
  # 5.  Quantity must be greater than 0
  
  
  def by_merchant(id)
    product = Product.find_by(id: self.product_id)
    if product.merchant_id == id
      return product
    end
  end
  
  private
  def get_subtotal
    # put it here?  call this when creating/updating an order_item instance
  end
  
end
