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
      user = User.new(:first_name => params[:first_name], :last_name => params[:last_name], :about_me => params[:about_me] :username => params[:username], :email => params[:email], :password => params[:password])
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
    if logged_in?
      if current_user = @user
        erb :'users/user_info'
      else
        flash[:message] 
        redirect '/events'
      end
    else
      redirect 'login'
    end
  end
  
  get '/user/:slug/edit/password_verfication' do
  end
  
  get '/user/:slug/edit' do
    @user = User.find_by_slug(params[:slug])
    if logged_in?
      if current_user == @user
        erb :'user/update_user'
      else
        flash[:message] = "You are not authorized to view this page."
        redirect '/events'
      end
    else
      redirect '/login'
    end
  end
  
  patch '/users/:slug' do
    @user = User.find_by_slug(params[:slug])
    if logged_in?
      if @user == current_user
        if params.any? {|key, value| value.strip.length == 0}
          flash[:message] = "Entries cannot be empty."
          redirect "/user/#{params[:slug]}/edit"
        else
          @user.update(first_name: params[:first_name], last_name: params[:last_name], about_me: params[:about_me], username: params[:username], email: params[:email], password: params[:password])
          redirect '/events'
        end
      else
        flash[:message] = "You are not authorized to make this request."
        redirect '/events'
      end
    else
      redirect '/login'
    end
  end
  
    # class CreateUsers < ActiveRecord::Migration[5.2]
  # def change
  #   create_table :users do |t|
  #     t.string :first_name
  #     t.string :last_name
  #     t.text :about_me
  #     t.string :username
  #     t.string :password_digest
  #     t.string :email
  #     t.timestamps
  #   end
  # end
# end
  get '/user/:slug/delete_account/password_verfication' do
  end

  delete '/user/:slug/delete_account' do
    @user = User.find_by_slug(params[:slug])
    if logged_in?
      if current_user == @user
        @user.delete
        redirect '/'
      else
        flash[:message] = "You are not authorized to make this request."
        redirect '/events'
      end
    else
      redirect '/login'
    end
  end
  
  get 'users/:slug/events_hosted' do
    @user = User.find_by_slug(params[:slug])
    if logged_in?
        erb :"users/:user_events"
    else
    
      redirect '/login'
    end
  end
  
end
