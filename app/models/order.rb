class Order < ApplicationRecord
  
  has_many :order_items
  
  validates :order_items, presence: true
  
  
  private
  
  def get_grand_total
    # I think it goes here b/c business logic?
    # call this only upon payment? at same time as flipping status from 'pending' to 'done'?
  end
  
end
