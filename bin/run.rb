
require './config/environment.rb'
require_relative '../lib/cli_model.rb'


require 'nokogiri'
require 'pry'
require 'open-uri'

require_relative '../lib/models/location.rb'
require_relative '../lib/models/film.rb'
require_relative '../lib/models/film_location.rb'


new_cli = CommandLineInterface.new
new_cli.run


# pry.start
