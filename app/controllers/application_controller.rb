require 'rack-flash'
require './config/environment'

class ApplicationController < Sinatra::Base
  configure do 
    enable :sessions
    set :session_secret, "s3c43t"
    set :public_folder, 'public'
    set :views, 'app/views'
  end
  
  use Rack::Flash
  
  get '/' do 
    erb :"index"
  end

  helpers do
    def logged_in?
      !!session[:user_id]
        # if !User.exists?(session[:user_id])
        #   redirect '/logout'
        # end
      
    end

    def current_user
      User.find(session[:user_id])
    end
  end
  
end

puts "app controller has been accessed"