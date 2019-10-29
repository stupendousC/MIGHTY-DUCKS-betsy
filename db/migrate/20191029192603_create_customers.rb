class CreateCustomers < ActiveRecord::Migration[5.2]
  def change
    create_table :customers do |t|
      t.string :name
      t.string :email
      t.string :address
      t.string :city
      t.string :state
      t.integer :zip
      
      t.string :cc_name
      t.integer :cc
      t.string :cc_exp_month
      t.string :cc_exp_year
      t.string :cc_exp
      t.integer :cvv
      
      t.timestamps
    end
  end
end
