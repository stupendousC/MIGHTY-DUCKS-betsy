class SplitCcTo4FieldsInCustomers < ActiveRecord::Migration[5.2]
  def change
    remove_column :customers, :cc 
    
    add_column :customers, :cc1, :integer
    add_column :customers, :cc2, :integer
    add_column :customers, :cc3, :integer
    add_column :customers, :cc4, :integer
  end
end
