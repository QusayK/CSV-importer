class AddIndexToActorsName < ActiveRecord::Migration[7.1]
  def change
    add_index :actors, 'LOWER(name)', name: 'index_actors_on_lower_name'
  end
end
