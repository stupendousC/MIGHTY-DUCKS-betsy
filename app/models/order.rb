class Order < ApplicationRecord
  
  has_many :order_items  
  
  validates :name, presence: true
  validates :email, presence: true, format: { with: /\A[^@\s]+@([^@.\s]+\.)+[^@.\s]+\z/ } 
  validates :address, presence: true
  validates :cc, presence: true
  
  private
  
  def get_grand_total
    # I think it goes here b/c business logic?
    # call this only upon payment? at same time as flipping status from 'pending' to 'done'?
  end
  
end
