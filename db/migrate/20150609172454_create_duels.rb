class CreateDuels < ActiveRecord::Migration
  def change
    create_table :duels do |t|

      t.timestamps null: false
    end
  end
end
