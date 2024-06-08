class AddUniqueIndexToFilmingLocationsName < ActiveRecord::Migration[7.1]
  def change
    add_index :filming_locations, :name, unique: true
  end
end
