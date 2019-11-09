class EventsController < ApplicationController
  get '/events' do 
    if logged_in?
      @events = Events.all
      erb :'events/event_index'
    else
      redirect '/login'
    end
  end
  
  get '/events/new' do 
    if logged_in?
      erb :'/events/create_event'
    else
      redirect '/login'
    end
  end
  
  post '/events' do 
    if logged_in?
      if params.any? {|key, value| value.strip.length == 0}
        event = Event.new(:event_name => params[:event_name], :event_type => params[:event_type], :event_description => params[:event_description], :user_id => current_user.id)
        event.save
        redirect '/events'
      else
        flash[:message] = "You cannot have a blank entry."
        redirect '/events/new'
      end
    else
      redirect '/login'
    end
  end

  get '/events/:id' do
    if logged_in?
      @event = Event.find_by_id(params[:id])
      erb :'events/show_event'
    else
      redirect 'login'
    end
  end
  
  get '/events/:id/edit' do 
    @event = Event.find_by_id(params[:id])
    if logged_in?
      if current_user == @event.user
        erb :'events/edit_event'
      else
        flash[:message] = "You are not authorzed to view this page."
        redirect '/events'
      end
    else
      redirect '/login'
    end
  end
  
  patch '/events/id' do 
    @event = Event.find_by_id(params[:id])
    if logged_in?
      if @event
        if current_user == @event.user
          if params.any? {|key, value| value.strip.length == 0}
            flash[:message] = "Entries cannot be blank."
            redirect "/events/#{params[:id]}/edit"
          else
            @event.update
            # @event.update(event_name: params[:event_name], event_type: params[:event_type], description: params[:description])
            redirect "/events/#{@event.id}"
          end
        else
          flash[:message] = "You are not authrized to view this page."
          redirect '/events'
        end
      else
        flash[:message] = "This page does not exist"
        redirect '/events'
      end
    else
      redirect '/login'
    end
  end
  
  delete '/events/id/delete' do 
    @event = Event.find_by_id(params[:id])
    if logged_in?
      if current_user == @event.user
        @event.delete
      end
      redirect '/events'
    else
      redirect '/login'
    end
  end
  
end

    #   class CreateEvents < ActiveRecord::Migration[5.2]
#   def change
#     create_table :events do |t|
#       t.string :event_name
#       t.string :event_type
#       t.text :description
#       t.timestamps null: :false
#     end
#   end
# end

# <a href "/my_events">Home</a> <a href "/events">Events Trending</a> <a href "/login">Login</a> <a href "/logout">Logout</a> 
