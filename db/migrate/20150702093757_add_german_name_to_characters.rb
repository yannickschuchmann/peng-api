class AddGermanNameToCharacters < ActiveRecord::Migration
  def change
    add_column :characters, :name_de, :string
  end
end
