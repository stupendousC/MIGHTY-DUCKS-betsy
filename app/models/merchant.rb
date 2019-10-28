class Merchant < ApplicationRecord
  has_many :products
  
  validates :name, presence: true, uniqueness: true
  
  # email format regex from stackoverflow.com https://stackoverflow.com/questions/4770133/rails-regex-for-email-validation
  validates :email, presence: true, uniqueness: true, format: { with: /\A[^@\s]+@([^@.\s]+\.)+[^@.\s]+\z/ } 
  
  def self.build_from_github(auth_hash)
    # assembling Merchant.new() using info from github's auth_hash
    merchant = Merchant.new
    merchant.uid = auth_hash[:uid]
    merchant.provider = "github"
    if auth_hash[:info][:name]
      merchant.name = auth_hash[:info][:name]
    elsif auth_hash[:info][:nickname]
      merchant.name = auth_hash[:info][:nickname]
    end
    merchant.email = auth_hash[:info][:email]
    
    # will Merchant.save() later inside ctrller
    return merchant
  end
  
end
