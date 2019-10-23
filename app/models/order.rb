class Order < ApplicationRecord
  
  has_many :order_items
  
  #VALIDATIONS
  # 1.  must have 1 or more items
  
  
  
  
  private
  def get_grand_total
    # I think it goes here b/c business logic?
    # call this only upon payment? at same time as flipping status from 'pending' to 'done'?
  end
  
end
