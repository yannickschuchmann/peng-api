class CreateActors < ActiveRecord::Migration
  def change
    create_table :actors do |t|
      t.belongs_to :user, index: true
      t.belongs_to :duel, index: true
      t.integer :hit_points
      t.integer :shots
      t.string :type

      t.timestamps null: false
    end
  end
end
