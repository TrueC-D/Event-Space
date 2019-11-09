ENV['SINATRA_ENV'] ||= "development"


require 'bundler/setup'
require 'active_record'
require 'require_all'
Bundler.require(:default, ENV['SINATRA_ENV'])

require 'sinatra'

# if ActiveRecord::Migrator.needs_migration?
#   raise 'Migrations are pending. Run `rake db:migrate` to resolve the issue.'
# end

configure :development do 
  set :database, 'sqlite3:db/database.db'
end

# if ActiveRecord::Migrator.needs_migration?
#   raise 'Migrations are pending. Run `rake db:migrate` to resolve the issue.'
# end

require_all 'app'

