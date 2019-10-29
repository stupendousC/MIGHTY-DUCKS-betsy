class Order < ApplicationRecord
  
  before_save :default_status
  
  has_many :order_items  
  
  def default_status
    self.status ||= "pending"
  end
  
  
  def get_grand_total
    self.status = "paid"
    total = 0
    self.order_items.each do |item|
      total += item.subtotal
    end
    return total
  end
  
end
