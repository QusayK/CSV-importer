class ModifyMovies < ActiveRecord::Migration[7.1]
  def change
    remove_column :movies, :country, :string
    remove_column :movies, :filming_location, :string
    add_reference :movies, :country, foreign_key: true
    add_reference :movies, :filming_location, foreign_key: true
  end
end
