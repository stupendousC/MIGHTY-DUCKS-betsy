module ApplicationHelper
  
  def display_date(date_obj)
    # Returns a date obj as a string, in the format of "Oct 21, 2019"
    return date_obj.getlocal.strftime("%b %d, %Y")
  end
  
  def usd(cents_integer)
    # Returns integer argument as a string.  Ex: usd(199) returns "$1.99"
    return format("$%.2f", cents_integer/100.0)
  end
  
  def get_string_of_names(collection)
    # collection = [ whatever instance w/ an attr called .name]
    # therefore can be used on [Category instances], [Product instances], or [Merchant instances]
    # returns a string of comma-separated names.
    # ex: get_string_of_names([p1, p2, p3]) = "apple, orange, melon"
    
    if collection.length >= 1
      string = "#{collection.first.name.capitalize}"
    else 
      return "None"
    end
    
    (collection.length - 1).times do |index|
      string << ", #{collection[index+1].name.capitalize}"
    end    
    
    return string
  end
  
  def first_x_chars(string, x=5)
    # returns string of the first x number of characters, followed by ... if it's long enough
    # default cutoff will be 5 characters unless you specify what x is
    final = string[0..x-1]
    final << "..." if string.length > x
    return final
  end
  
  def make_thumbnail_link(productInstance)
    # take a Product instance, and returns erb for a picture of the product's image 
    # which upon clicking will lead u to that product's show page
    # ex: <%= make_thumbnail_link(@product1) %> 
    if productInstance.class == Product
      return link_to image_tag(productInstance.img_url, alt: 'picture of #{productInstance.name}', class: 'thumbnail'), product_path(id: productInstance.id)
    else
      return "INVALID"
    end
  end
end
