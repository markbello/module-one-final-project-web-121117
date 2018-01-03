# require_relative '../../bin/run.rb'

class Location < ActiveRecord::Base
  has_many :film_locations
  has_many :films, through: :film_locations

  def create_location_row
    Location.create(city_name: city_name, state_name: state_name, country_name: country_name)
  end




end
