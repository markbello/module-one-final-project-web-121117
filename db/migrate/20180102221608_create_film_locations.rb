class CreateFilmLocations < ActiveRecord::Migration[5.0]
  def change
    create_table :film_locations do |t|
      t.integer :film_id
      t.integer :location_id
    end
  end
end
