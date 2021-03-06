ENV['SINATRA_ENV'] ||= "development"

require 'bundler/setup'
# require 'active_record'
# require 'require_all'
Bundler.require(:default, ENV['SINATRA_ENV'])

ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: "db/#{ENV['SINATRA_ENV']}.sqlite")

configure :development do 
  set :database, 'sqlite3:db/database.db'
end

require_all 'app'
require 'pry'
require 'sinatra'

# require_relative '../app/views/users'

puts 'environment has been accessed'

