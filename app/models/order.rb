class Order < ApplicationRecord
  # I need to explicitly include ApplicationHelper if I want to use them here 
  # (for some reason, that module is freely available to Views html files)
  include ApplicationHelper     
  
  before_save :default_status
  
  has_many :order_items
  
  # assign to temporary default "customer" until purchase finalized 
  # belongs_to :customer
  
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
  
  def names_from_order_items(array_of_order_items)
    collection = []
    if array_of_order_items.respond_to? :each
      array_of_order_items.each do |order_item_instance|
        collection << order_item_instance.product
      end
      return get_string_of_names(collection)
    else
      return "Invalid argument, expecting an array of Order Item instances"
    end
  end
  
  
end
