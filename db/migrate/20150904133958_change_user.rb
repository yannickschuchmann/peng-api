class ChangeUser < ActiveRecord::Migration
  def change
    add_column :users, :first_name, :string
    add_column :users, :email, :string
    add_column :users, :profile, :string
    remove_column :users, :uid
  end
end
