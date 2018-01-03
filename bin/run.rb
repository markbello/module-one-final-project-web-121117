
require './config/environment.rb'
require_relative '../lib/cli_model.rb'


require 'nokogiri'
require 'pry'
require 'open-uri'

require_relative '../lib/models/location.rb'
require_relative '../lib/models/film.rb'
require_relative '../lib/models/film_location.rb'


#GET http://www.imdb.com/search/title?locations=Albany,%20New%20York,%20USA&ref_=ttloc_loc_2 for "Albany, NY"
    #http://www.imdb.com/search/title?locations=albany,%20new,%20york,%20USA&ref_=ttloc_loc_2
#GET http://www.imdb.com/title/tt0944835/locations?ref_=tt_dt_dt for "Salt Locations"

#SCRAPE the HTML for Albany First
#TARGET div.lister-list > div.lister-item > div.lister-item-content > h3 a (most specific)
#doc.css("div.lister-list > div.lister-item")
#LOOP through each item in the list and add it to an array

#SCRAPE the HTML for "Salt" movie locations
#TARGET #filming_locations_content > div.soda dt

#GETS user input
#ENCODE URI for scraping by location

#FUTURE DEV: consider asking the country first, because it affects how to structure our GET requests
#            State is only required for US locations


  new_cli = CommandLineInterface.new
  new_cli.run


# pry.start
