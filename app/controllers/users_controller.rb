class UsersController < ApplicationController
  get '/signup' do
    if logged_in?
      redirect '/tweets'
    else
    erb :'users/signup'
    end
  end
  
  post '/signup' do
    if params[:username] == ''|| params[:password] == ''|| params[:email] == ''
      redirect '/signup'
    else User.create(username: params[:username], email: params[:email], password: params[:password])
      redirect '/tweets'
    end
  end
  
  get '/login' do
    erb :'users/login'
  end
  post '/login' do 
    redirect '/account'
  end
  
  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end
  end
end
