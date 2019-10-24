class AddGithubColumnsToMerchants < ActiveRecord::Migration[5.2]
  def change
    add_column :merchants, :uid, :string
    add_column :merchants, :provider, :string
  end
end
