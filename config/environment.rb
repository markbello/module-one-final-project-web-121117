require 'bundler'
require 'nokogiri'
require 'pry'



Bundler.require

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')

require_all 'lib'
