class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.integer :grand_total
      t.string :status
      
      t.timestamps
    end
  end
end
