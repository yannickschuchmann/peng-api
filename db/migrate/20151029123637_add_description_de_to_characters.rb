class AddDescriptionDeToCharacters < ActiveRecord::Migration
  def change
    add_column :characters, :description_de, :text
  end
end
