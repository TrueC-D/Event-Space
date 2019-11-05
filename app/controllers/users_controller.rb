class UsersController < ApplicationController
  get '/signup' do
    if logged_in?
      redirect '/event_index'
    else
    erb :'users/create_user'
    end
  end
  
  post '/signup' do
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
