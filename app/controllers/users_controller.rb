class UsersController < ApplicationController
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
  
  get 'users/:slug/events_hosted' do
    @user = User.find_by_slug(params[:slug])
    if logged_in?
        erb :"users/events_hosted"
    else
      redirect '/login'
    end
  end
  
  get 'user/:slug/events_attending' do 
    @user = User.find_by_slug(params[:slug])
    if logged_in?
      if @user == current_user 
        erb :"users/events_attending"
      else
        redirect '/events'
      end
    else
      redirect '/login'
    end
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
      user = User.new(first_name: params[:first_name], last_name: params[:last_name], about_me: params[:about_me], username: params[:username], email: params[:email], password: params[:password])
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
  
  get '/logout' do
    if logged_in?
      session.clear
      redirect 'login'
    else
      redirect '/'
    end
  end
  
  get '/user/:slug/edit/password_verfication' do
    @user = User.find_by_slug(params[:slug])
    @destination = "edit"
    if logged_in?
      if current_user == @user
        erb :'/user/password_verfication'
      else
        redirect '/events'
      end
    else
      redirect '/login'
    end
  end
  
  post '/user/:slug/edit/password_verfication' do
    @user = User.find_by_slug(params[:slug])
    if logged_in?
      if current_user == @user
        if params[:password1] == [:password2]
          if @user.authenticate(params[:password1])
            session[:password_verfication] = "true-editing"
            redirect "/user/#{@user.slug}/edit"
          else
            flash[:message] = "Password is incorrect."
            redirect "user/#{@user.slug}/edit/password_verfication"
          end
        else
          flash[:message] = "Your entries did not match."
          redirect "user/#{@user.slug}/edit/password_verfication"
        end
      else
        redirect '/events'
      end
    else
      redirect '/login'
    end
  end
  
  get '/user/:slug/edit' do
    @user = User.find_by_slug(params[:slug])
    if logged_in?
      if current_user == @user
        if session[:password_verfication] == "true-editing"
          session[:password_verfication] = "pending"
          erb :'user/update_user'
        else
          redirect "user/#{@user.slug}/edit/password_verfication"
        end
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
          if session[:password_verfication] == "pending"
            session[:password_verfication] = "false"
            @user.update(first_name: params[:first_name], last_name: params[:last_name], about_me:   params[:about_me], username: params[:username], email: params[:email], password: params[  :password])
            redirect '/events'
          else
            redirect "user/#{@user.slug}/edit/password_verfication"
          end
        end
      else
        flash[:message] = "You are not authorized to make this request."
        redirect '/events'
      end
    else
      redirect '/login'
    end
  end

  get '/user/:slug/delete_account/password_verfication' do
    @user = User.find_by_slug(params[:slug])
    @destination = "delete_account"
    if logged_in?
      if current_user == @user
        erb :'/user/password_verfication'
      else
        redirect '/events'
      end
    else
      redirect '/login'
    end
  end
  
  post '/user/:slug/delete_account/password_verfication' do
    @user = User.find_by_slug(params[:slug])
    if logged_in?
      if current_user == @user
        if params[:password1] == [:password2]
          if @user.authenticate(params[:password1])
            session[:password_verfication] = "true-deleting"
            redirect "/user/#{@user.slug}/delete_account"
          else
            flash[:message] = "Password is incorrect."
            redirect "user/#{@user.slug}/delete_account/password_verfication"
          end
        else
          flash[:message] = "Your entries did not match."
          redirect "user/#{@user.slug}/delete_account/password_verfication"
        end
      else
        redirect '/events'
      end
    else
      redirect '/login'
    end
  end

  delete '/user/:slug/delete_account' do
    @user = User.find_by_slug(params[:slug])
    if logged_in?
      if current_user == @user
         if session[:password_verfication] == "true-deleting"
            session[:password_verfication] = "false"
            @user.delete
            redirect '/'
          else
            redirect "user/#{@user.slug}/delete_account/password_verfication"
          end
      else
        flash[:message] = "You are not authorized to make this request."
        redirect '/events'
      end
    else
      redirect '/login'
    end
  end
  
end
