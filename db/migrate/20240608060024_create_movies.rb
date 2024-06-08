class CreateMovies < ActiveRecord::Migration[7.1]
  def change
    create_table :movies do |t|
      t.string :title
      t.text :description
      t.integer :year
      t.references :director, null: false, foreign_key: true
      t.string :country
      t.string :filming_location

      t.timestamps
    end
  end
end
