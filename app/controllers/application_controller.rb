class ApplicationController < ActionController::Base
  before_action :find_order
  before_action :category_index
  
  def find_order
    @order = Order.find_by(id: session[:order_id])
  end
  
  def category_index
    @categories = Category.all
  end
  
  ### The one in application_helper.rb only works in .html, this one is for ctrller use
  def get_string_of_names(collection)
    # collection = [ whatever instance w/ an attr called .name]
    # therefore can be used on [Category instances], [Product instances], or [Merchant instances]
    # returns a string of comma-separated names.
    # ex: get_string_of_names([p1, p2, p3]) = "apple, orange, melon"
    
    if (collection.respond_to? :each)
      if (collection.length >= 1) && (collection.first.respond_to? :name)
        string = "#{collection.first.name.capitalize}"
      else 
        return "None"
      end
    end
    
    (collection.length - 1).times do |index|
      string << ", #{collection[index+1].name.capitalize}"
    end    
    
    return string
  end
end
