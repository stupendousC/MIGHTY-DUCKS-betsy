class Category < ApplicationRecord
  has_and_belongs_to_many :products
  
  # VALIDATIONS?  Not sure, probably presence of name since that's the only attribute...
end
