class AddColumnsToFilms < ActiveRecord::Migration[5.1]
  def change
    add_column :films, :link, :string
    
  end
end
