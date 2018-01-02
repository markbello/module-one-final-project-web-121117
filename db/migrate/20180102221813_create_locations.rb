class CreateLocations < ActiveRecord::Migration[5.0]
  def change
    create_table :locations do |t|
      t.string :city_name
      t.string :state_name
      t.string :country_name
    end
  end
end
