class RemoveStatusFromDuels < ActiveRecord::Migration
  def change
    remove_column :duels, :status, :string
  end
end
