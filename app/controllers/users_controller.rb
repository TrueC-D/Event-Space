class UsersController < ApplicationController
  get '/users/:slug' do
    @user = User.find_by_slug(params[:slug])
    if logged_in?
      if current_user = @user
        erb :'users/user_info'
      else
        flash[:message] = "You are not authorized to view this page."
        redirect '/events'
      end
    else
      redirect 'login'
    end
  end
  
  get '/users/:slug/events_hosted' do
    @user = User.find_by_slug(params[:slug])
    if logged_in?
        erb :"users/events_hosted"
    else
      redirect '/login'
    end
  end
  
  get '/users/:slug/events_attending' do 
    @user = User.find_by_slug(params[:slug])
    @event = Event.all
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
      session[:user_id] = @user.id
      redirect '/events'
    else
      flash[:message] = "Your credentials are incorrect. Please try again."
      redirect '/login'
    end
  end
  
  get '/logout' do
      session.clear
      redirect '/'
  end
  
  get '/users/:slug/edit/password_verification' do
    @user = User.find_by_slug(params[:slug])
    @destination = "edit"
    if logged_in?
      if current_user == @user
        erb :'/users/password_verification'
      else
        redirect '/events'
      end
    else
      redirect '/login'
    end
  end
  
  post '/users/:slug/edit' do 
    @user = User.find_by_slug(params[:slug])
    if logged_in?
      if current_user == @user
        if params[:password1] == params[:password2]
          if @user.authenticate(params[:password1])
            session[:password_verification] = "true"
            erb :'users/update_user'
          else
            flash[:message]= "Password is incorrect."
            redirect "/users/#{@user.slug}/edit/password_verification"
          end
        else
          flash[:message]="Your entries did not match."
          redirect "/users/#{@user.slug}/edit/password_verification"
        end
      else
        flash[:message]="You are not authorized to view this page"
        redirect "/events"
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
          redirect "/users/#{params[:slug]}/edit"
        else
          if session[:password_verification] == "true"
            session[:password_verification] = "false"
            @user.update(first_name: params[:first_name], last_name: params[:last_name], about_me:   params[:about_me], username: params[:username], email: params[:email])
            redirect "/users/#{@user.slug}"
          else
            redirect "users/#{@user.slug}/edit/password_verification"
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

  get '/users/:slug/update_password' do
    @user = User.find_by_slug(params[:slug])
    if logged_in?
      if current_user == @user
        erb :'/users/update_password'
      else
        flash[:message]="You are not authorized to view this page."
        redirect '/events'
      end
    else
      redirect '/login'
    end
  end
  
  patch '/users/:slug/update_password' do 
    @user = User.find_by_slug(params[:slug])
    if logged_in?
      if current_user == @user
        if @user.authenticate(params[:password])
          if params[:newpassword] == params[:newpassword_confirmed]
            @user.update(password: params[:newpassword])
            flash[:message]= "password change successful"
            redirect "/users/#{@user.slug}"
          else
            flash[:message] = "Your new passwords do not match."
            redirect "/users/#{@user.slug}/update_password"
          end
        else 
          flash[:message]="Invalid original password."
          redirect "/users/#{@user.slug}/update_password"
        end
      else
        flash[:message]="You are not authorized to view this page"
        redirect '/events'
      end
    else
      redirect '/login'
    end
  end
  
  delete '/users/:slug/delete_account' do
    @user = User.find_by_slug(params[:slug])
    if logged_in?
      if current_user == @user
         if session[:password_verification] == "true"
            session[:password_verification] = "false"
            @user.event_attendees.each{|attendance| attendance.delete}
            @user.events.each do |event|
              event.event_attendees.each{|attendee| attendee.delete}
              event.delete
            end
            @user.delete
            session.clear
            redirect '/'
            redirect "/users/#{params[:slug]}"
          else
            redirect "/users/#{@user.slug}/edit/password_verification"
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

puts "users controller has been accessed"
