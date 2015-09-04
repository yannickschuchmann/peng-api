class CreateUserProviders < ActiveRecord::Migration
  def change
    create_table :user_providers do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.string :oauth_provider
      t.string :oauth_uid

      t.timestamps null: false
    end
  end
end
