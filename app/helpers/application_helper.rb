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
    final = string[0..x-1]
    final << "..." if string.length > x
    return final
  end
end

