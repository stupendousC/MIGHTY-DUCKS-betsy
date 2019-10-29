class Order < ApplicationRecord
  
  before_save :default_status
  
  has_many :order_items  
  
  def default_status
    self.status ||= "pending"
  end
  
  
  def get_grand_total
    # Kelsey, can we PLEASE do this AFTER payment? 
    # cuz we'll need to display this for viewing show.html
    # self.status = "paid"
    
    total = 0
    self.order_items.each do |item|
      total += item.subtotal
    end
    return total
  end
  
  
  
  #### Caroline made this
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
  
  #### Caroline made this
  def missing_stock
    # Checks if all order_items are in stock, return nil if yes
    # else, return [out_of_stocks order_items]
    out_of_stocks = []
    
    self.order_items.each do |order_item|
      unless order_item.in_stock?
        out_of_stocks << order_item
      end
    end
    
    if out_of_stocks.any?
      return out_of_stocks
    else
      return nil
    end
  end
  
end
