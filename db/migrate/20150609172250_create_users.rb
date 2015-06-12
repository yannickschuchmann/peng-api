class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :uid
      t.string :nick
      t.string :phone

      t.timestamps null: false
    end
  end
end
