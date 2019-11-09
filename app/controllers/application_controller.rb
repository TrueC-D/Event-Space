require 'rack-flash'
require './config/environment'

class ApplicationController < Sinatra::Base
  configure do 
    enable :sessions
    set :session_secret, "s3c43t"
    set :public_folder, 'public'
    set :views, 'app/views'
  end
  
  get '/' do 
    erb :"index"
  end
  
  # <a href "/my_events">Home</a> <a href "/events">Events Trending</a> <a href "/login">Login</a> <a href "/logout">Logout</a> 

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end
  end
  
end