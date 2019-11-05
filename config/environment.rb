# ENV['SINATRA_ENV'] ||= "development"

require 'bundler/setup'
# Bundler.require(:default, ENV['SINATRA_ENV'])

if ActiveRecord::Migrator.needs_migration?
  raise 'Migrations are pending. Run `rake db:migrate` to resolve the issue.'
end

configure :development do 
  set :database,
  'sqlite3:db/database.db'
end

require_all 'app'

# require 'sinatra'