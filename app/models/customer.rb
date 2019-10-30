class Customer < ApplicationRecord
  has_many :orders
  
  validates :name, presence: true
  validates :email, presence: true, format: { with: /\A[^@\s]+@([^@.\s]+\.)+[^@.\s]+\z/ } 
  validates :address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zip, presence: true
  
  validates :cc_company, presence: true
  validates :cc_name, presence: true
  validates :cc1, presence: true
  validates :cc2, presence: true
  validates :cc3, presence: true
  validates :cc4, presence: true
  validates :cc_exp_month, presence: true
  validates :cc_exp_year, presence: true
  validates :cvv, presence: true
  
end
