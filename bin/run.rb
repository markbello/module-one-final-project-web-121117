
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



#Film.all.each{|film| film.locations << albany}

# def get_film_seeds_by_location(url)
#   film_hash_array = []
#   # html_by_location = open("http://www.imdb.com/search/title?locations=Los%20Angeles,%20California,%20USA&ref_=tt_dt_dt")
#   html_by_location = open(url)
#   location_doc = Nokogiri::HTML(html_by_location)
#   location_data = location_doc.css("div.lister-list > div.lister-item")
#   location_data.each do |location_item|
#     film_hash = {}
#
#     film_hash[:name] = location_item.css("div.lister-item-content > h3 a").text
#
#     film_year = /\d{4}/.match(location_item.css("div.lister-item-content > h3 a + span").text)
#     film_year.class == MatchData ? film_year = film_year[0] : film_year = "Not Listed"
#     film_hash[:year] = film_year
#
#     film_people = location_item.css("div.lister-item-content > div.ratings-bar + p.text-muted + p a").map do |name|
#       person_hash = {}
#       person_hash[:name] = name.text
#       link = name.attributes["href"].value
#       person_hash[:link] = link
#       person_hash
#     end
#
#     film_hash[:director] = film_people[0]
#     film_people.shift
#     film_hash[:stars] = film_people
#
#     film_imdb_id = location_item.css("div.lister-item-content > h3.lister-item-header a")[0].attributes["href"].value
#     film_hash[:link] = film_imdb_id
#     film_hash_array << film_hash
#   end
#   film_hash_array
# end

# def get_location_seeds_by_film_name
#   location_hash_array = []
#   html_by_location = open("http://www.imdb.com/title/tt0944835/locations?ref_=tt_dt_dt")
#
#   location_doc = Nokogiri::HTML(html_by_location)
#   location_data = location_doc.css("#filming_locations_content")
#   location_data.css("div.soda > dt a").each do |location_item|
#     location_hash = {}
#     location_hash[:name] = location_item.text.chomp
#     location_hash[:link] = location_item.attributes["href"].value
#     location_hash_array << location_hash
#   end
#   location_hash_array
# end

# pry.start
#
# html_by_location = open("http://www.imdb.com/search/title?locations=Albany,%20New%20York,%20USA&ref_=ttloc_loc_2")
# html_by_movie = open("http://www.imdb.com/title/tt0944835/locations?ref_=tt_dt_dt")
#
# location_doc = Nokogiri::HTML(html_by_location)
# movie_doc = Nokogiri::HTML(html_by_movie)
#
# test_by_location = location_doc.css("div.lister-list > div.lister-item").map {|location_item| location_item.css("div.lister-item-content > h3 a").text}
# test_by_location_year = location_doc.css("div.lister-list > div.lister-item").map {|location_item| location_item.css("div.lister-item-content > h3 a + span").text}
# # test_by_location_year.map{ |year_record| /\d{4}/.match(year_record) }
#
#
#
# test_by_movie_name = movie_doc.css("#filming_locations_content > div.soda dt").map {|movie_name_item| movie_name_item.text}
# #
# # puts "Please provide the name of the country:"
# country_name = gets.chomp.downcase
# puts "Enter City Name"
# city_name = gets.chomp
#
#
# city_name_array = city_name.split(" ")

  #
  # if country_name == "usa"
  #   puts "Enter State"
  #
  #   state_name = gets.chomp
  #   state_name_array = state_name.split(" ")
  #
  #   full_location_name = city_name_array.join(",%20") + ",%20" + state_name_array.join(",%20") + ",%20USA"
  #   # new_state_name = state_name_array.join(",%20")
  #   html_by_input_location = open("http://www.imdb.com/search/title?locations=#{full_location_name}&ref_=ttloc_loc_2")
  #     # create_location_row
  # else
  #   foreign_location_name = "#{city_name},+#{country_name}"
  #   html_by_input_location = open("http://www.imdb.com/search/title?locations=#{foreign_location_name}")
  # end

  # def get_film_title_link_by_name(name)
  #   html = open("http://www.imdb.com/find?ref_=nv_sr_fn&q=#{name}&s=tt")
  #   doc = Nokogiri::HTML(html)
  #   url = doc.css("table.findList tr a")[0].attributes["href"].value
  # end

  # pry.start

  new_cli = CommandLineInterface.new
  new_cli.run


# pry.start
