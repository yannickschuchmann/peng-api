class AddBetAndStatusToDuels < ActiveRecord::Migration
  def change
    add_column :duels, :bet, :string
    add_column :duels, :status, :string
  end
end
