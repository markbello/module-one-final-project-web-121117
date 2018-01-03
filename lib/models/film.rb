class Film < ActiveRecord::Base
  has_many :film_locations
  has_many :locations, through: :film_locations

  
end
