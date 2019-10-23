class Product < ApplicationRecord
  has_many :reviews
  has_many :order_items
  belongs_to :merchant
  has_and_belongs_to_many :categories
  
  # VALIDATION: TODO in Trello
  # 1.  Name must be present
  # 2.  Name must be unique
  # 3.  Price must be present
  # 4.  Price must be a number
  # 5.  Price must be greater than 0
  # 6.  Product must belong to a Merchant
  
end
