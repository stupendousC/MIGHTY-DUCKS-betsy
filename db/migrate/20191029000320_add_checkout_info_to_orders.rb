class AddCheckoutInfoToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :name, :string
    add_column :orders, :email, :string
    add_column :orders, :address, :string
    add_column :orders, :city, :string
    add_column :orders, :state, :string
    add_column :orders, :zip, :integer
    
    add_column :orders, :cc, :integer
    add_column :orders, :cc_exp, :string
    add_column :orders, :cvv, :integer
  end
end
