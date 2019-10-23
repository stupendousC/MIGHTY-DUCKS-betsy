class Order < ApplicationRecord
  
  has_many :order_items
  
  #VALIDATIONS
  # 1.  must have 1 or more items
  
end
