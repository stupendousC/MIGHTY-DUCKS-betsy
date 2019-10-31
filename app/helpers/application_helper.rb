module ApplicationHelper
  
  def display_date(date_obj)
    # Returns a date obj as a string, in the format of "Oct 21, 2019"
    if date_obj.class == Date
      return date_obj.strftime("%b %d, %Y") 
    else
      return "INVALID DATE"
    end
  end
  
  def usd(cents_integer)
    # Returns integer argument as a string.  Ex: usd(199) returns "$1.99"
    if cents_integer.class == Integer 
      return format("$%.2f", cents_integer/100.0)
    else
      return "INVALID INTEGER"
    end
  end
  
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
    else 
      return "Invalid collection"
    end
    
    (collection.length - 1).times do |index|
      string << ", #{collection[index+1].name.capitalize}"
    end    
    
    return string
  end
  
  def first_x_chars(string, x=5)
    # returns string of the first x number of characters, followed by ... if it's long enough
    # default cutoff will be 5 characters unless you specify what x is
    if (string.class == String) && (x.class == Integer)
      final = string[0..x-1]
      final << "..." if string.length > x
      return final
    else
      return "INVALID"
    end
  end
  
  def make_thumbnail_link(productInstance)
    # take a Product instance, and returns erb for a picture of the product's image 
    # which upon clicking will lead u to that product's show page
    # ex: <%= make_thumbnail_link(@product1) %> 
    if productInstance.class == Product 
      if productInstance.img_url != nil
        return link_to image_tag(productInstance.img_url, alt: 'picture of ' + productInstance.name, class: 'thumbnail'), product_path(id: productInstance.id)
      else
        return "NO IMG AVAILABLE"
      end
    else
      return "INVALID"
    end
  end
  
  def customer_from_order_item(order_item)
    # called by customer_name() below, which checked the argument
    customer_id = order_item.order.customer_id
    if !customer_id
      return "Pending customer input"
    else
      return Customer.find_by(id: customer_id)
    end
  end
  
  def customer_name(order_item)
    unless order_item.respond_to? :order
      return "Invalid order_item instance"
    end
    
    customer_or_not = customer_from_order_item(order_item)
    if customer_or_not.respond_to? :name
      return customer_or_not.name.titleize    
    else
      return customer_or_not
    end
  end
  
  def order_status(order_item)
    if order_item.class == OrderItem
      return Order.find_by(id: order_item.order_id).status.capitalize
    else
      return "Invalid, expecting order_item instance"
    end
  end
  
  
  def total_price_of_array(array)
    # arrays must be either [order_item instances] or [orders instances]
    if array.respond_to? :each
      if array.first.respond_to? :subtotal
        # arrays are [order_item instances]
        return array.sum { |order_item| order_item.subtotal }
      elsif array.first.respond_to? :grand_total
        # arrays are [orders instances]
        return array.sum { |order| order.grand_total }
      else
        raise ArgumentError, "Array objects don't have subtotal or grand_total attributes"
      end
    else
      raise ArgumentError, "Must be arrays, of OrderItems or Orders instances"
    end
    
  end
  
end

