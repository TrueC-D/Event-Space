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
  end
  
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
  
  get '/users/:slug' do
    @user = User.find_by_slug(params[:slug])
    erb :'users/show'
  end
  
  get '/user/:slug/edit' do
    @user = User.find_by_slug(params[:slug])
    if logged_in?
      if current_user == @user
        erb :'user/update_user'
      else
        flash[:message] = "You are not authorized to view this page."
        redirect '/my_events'
      end
    else
      redirect '/login'
    end
  end
  
  patch '/user/:slug' do
    @user = User.find_by_slug(params[:slug])
    if logged_in?
      if @user == current_user
        if params.any? {|key, value| value.strip.length == 0}
          flash[:message] = "Entries cannot be empty."
          redirect "/user/#{params[:slug]}/edit"
        else
          @user.update
          # @user.update(first_name: params[:first_name])
          # @user.update(last_name: params[:last_name])
          # @user.update(email: params[:email])
          # @user.update(password: params[:password])
          redirect '/events'
        end
      else
        redirect '/my_events'
      end
    else
      redirect '/login'
    end
  end
  
  delete '/user/:slug/delete_account' do
    @user = User.find_by_slug(params[:slug])
    if logged_in?
      if current_user == @user
        @user.delete
        redirect '/'
      else
        redirect '/events'
      end
    else
      redirect '/login'
    end
  end
    
end
