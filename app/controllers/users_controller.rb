class UsersController < ApplicationController
  use Rack::Flash
  
  get '/users/:slug' do
    @user = User.find_by_slug(params[:slug])
    erb :'users/show'
  end
  
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
  end
  
  
  # <a href "/my_events">Home</a> <a href "/events">Events Trending</a> <a href "/login">Login</a> <a href "/logout">Logout</a> 

  
  get '/login' do
    if logged_in?
      redirect '/events'
    else
      erb :'users/user_login'
    end
  end
  
  post '/login' do 
    @user = User.find_by(:username=> params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.username
      redirect '/events'
    else
      flash[:message] = "Your credentials are incorrect. Please try again."
      redirect '/login'
    end
  end
  
  get '/edit_account_details' do
    erb "users/update_user"
  end
  
  delete '/delete_account' do
  end
  
  get '/logout' do
    if logged_in?
      session.clear
      redirect 'login'
    else
      redirect '/'
    end
  end
  
  def slug
    self.username.gsub(' ', '-').downcase
  end
  
  get '/users/#{user.slug}' do 
    user = User.find_by_slug(params[:slug])
    erb :'users/user_events'
  end
end
