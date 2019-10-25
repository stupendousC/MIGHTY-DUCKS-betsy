module ApplicationHelper
  
  def display_date(date_obj)
    # Returns a date obj as a string, in the format of "Oct 21, 2019"
    return date_obj.getlocal.strftime("%b %d, %Y")
  end
  
  def usd(cents_integer)
    # Returns integer argument as a string.  Ex: usd(199) returns "$1.99"
    return format("$%.2f", cents_integer/100.0)
  end
  
end
