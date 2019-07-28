require './config/environment'
class ApplicationController <Sinatra::Base
  configure do 
    enable :sessions
    set :session_secret, "secret"
  end
  
  get '/' do 
    erb :index
  end
  
end