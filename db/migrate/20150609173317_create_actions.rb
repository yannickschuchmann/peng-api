class CreateActions < ActiveRecord::Migration
  def change
    create_table :actions do |t|
      t.string :type
      t.belongs_to :round, index: true
      t.belongs_to :actor, index: true
      t.timestamps null: false
    end
  end
end
