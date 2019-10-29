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
  
  def customer_info_valid?
    must_be_present = [self.name, self.email, self.address, self.city, self.state, self.zip, self.cc_company, self.cc_name, self.cc, self.cvv, self.cc_exp]
    
    must_be_present.each do |piece|
      unless piece
        self.errors.full_messages << "#{piece.capitalize} required"
      end
    end
    
    if self.errors.full_messages
      return false
    else 
      return true
    end
    
  end
  
end
