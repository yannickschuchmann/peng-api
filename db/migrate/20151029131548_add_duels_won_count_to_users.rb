class AddDuelsWonCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :duels_won_count, :integer, default: 0
  end
end
