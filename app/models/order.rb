class Order < ApplicationRecord
  
  before_save :default_values
  
  has_many :order_items  
  
  # default_values code src:
  # https://stackoverflow.com/questions/1550688/how-do-i-create-a-default-value-for-attributes-in-rails-activerecords-model
  # retrieved 10/26/19
  
  def default_values
    self.status ||= "pending"
  end
  
  private
  
  def get_grand_total
    # I think it goes here b/c business logic?
    # call this only upon payment? at same time as flipping status from 'pending' to 'done'?
  end
  
end
