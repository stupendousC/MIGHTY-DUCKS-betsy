class AddCcCompanyToCustomers < ActiveRecord::Migration[5.2]
  def change
    add_column :customers, :cc_company, :string
  end
end
