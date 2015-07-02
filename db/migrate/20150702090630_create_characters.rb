class CreateCharacters < ActiveRecord::Migration
  def change
    add_column :users, :character_id, :integer
    add_index :users, :character_id
    create_table :characters do |t|
      t.string :name
      t.text :description
      t.timestamps null: false
    end
  end
end
