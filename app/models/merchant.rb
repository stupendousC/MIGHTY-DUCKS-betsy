class Merchant < ApplicationRecord
  has_many :products
  
  # VALIDATIONS: see Trello
  # 1.  Username must be present
  # 2.  Username must be unique
  # 3.  Email address must be present
  # 4.  Email address must be unique
end
