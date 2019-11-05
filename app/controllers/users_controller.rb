class UsersController < ApplicationController
  use Rack::Flash
  
  get '/signup' do
    if logged_in?
      redirect '/events'
    else
    erb :'users/create_user'
    end
  end
  
  post '/signup' do
    if params.any? {|key, value| value.strip.length == 0}
      flash[:message] = "Entries cannot be blank."
      redirect '/signup'
    elsif User.find_by(:username => params[:username])
       flash[:message] = "This username is taken."
      redirect '/signup'
    elsif User.find_by(:email => params[:email])
      flash[:message] = "An account is already associated to this e-mail."
      redirect '/signup'
    else
      user = User.new(:username => params[:username], :email => params[:email], :password => params[:password])
      user.save
      session[:user_id] = user.id
      redirect '/events'
  end
  
  
  # <a href "/my_events">Home</a> <a href "/events">Events Trending</a> <a href "/login">Login</a> <a href "/logout">Logout</a> 

  
  # post '/signup' do
  #   if params[:username] == ''|| params[:password] == ''|| params[:email] == ''
  #     redirect '/signup'
  #   else User.create(username: params[:username], email: params[:email], password: params[:password])
  #     redirect '/tweets'
  #   end
  # end
  
  get '/login' do
    erb :'users/user_login'
  end
  
  post '/login' do 
    
  end
  
  get '/edit_account_details' do
    erb "users/update_user"
  end
  
  delete '/delete_accpount' do
  end
  
  get '/logout' do
  end
  
end
