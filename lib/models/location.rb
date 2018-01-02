class Location < ActiveRecord::Base
  has_many :film_locations
  has_many :films, through: :film_locations

end
