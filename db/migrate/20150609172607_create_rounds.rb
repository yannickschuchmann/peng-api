class CreateRounds < ActiveRecord::Migration
  def change
    create_table :rounds do |t|
      t.belongs_to :duel, index: true
      t.integer :rid
      t.boolean :active

      t.timestamps null: false
    end
  end
end
