class RenameProfileOfUsersToPicture < ActiveRecord::Migration
  def change
    rename_column :users, :profile, :picture
  end
end
