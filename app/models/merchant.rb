class Merchant < ApplicationRecord
  has_many :products
  
  # VALIDATIONS: see Trello
  # 1.  merchantname must be present
  # 2.  merchantname must be unique
  # 3.  Email address must be present
  # 4.  Email address must be unique
  
  def self.build_from_github(auth_hash)
    # assembling Merchant.new() using info from github's auth_hash
    merchant = Merchant.new
    merchant.uid = auth_hash[:uid]
    merchant.provider = "github"
    merchant.name = auth_hash["info"]["name"]
    merchant.email = auth_hash["info"]["email"]
    
    # will Merchant.save() later inside ctrller
    return merchant
  end

end
