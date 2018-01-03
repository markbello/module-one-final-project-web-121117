require 'bundler'
require 'nokogiri'
require 'rest-client'
require 'pry'
require 'open-uri'



Bundler.require

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')

require_all 'lib'
