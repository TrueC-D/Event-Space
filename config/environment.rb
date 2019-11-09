# ENV['SINATRA_ENV'] ||= "development"

require 'bundler/setup'
require 'active_record'
require 'require_all'
# Bundler.require(:default, ENV['SINATRA_ENV'])

require 'sinatra'

configure :development do 
  set :database,
  'sqlite3:db/database.db'
end

require_all 'app'

