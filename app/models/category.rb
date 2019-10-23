class Category < ApplicationRecord
  has_many :products
  has_and_belongs_to_many :merchants
  
  # VALIDATIONS?  Not sure, probably presence of name since that's the only attribute...
end
