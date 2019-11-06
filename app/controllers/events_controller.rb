class EventsController < ApplicationController
  
  
  get '/events' do 
    erb :'events/event_index'
  end
  
  get '/events/:id' do
    @event = Event.find_by_id(params[:id])
    if @event 
      erb :'events/show_event'
    else
      redirect 'login'
    end
  end
  
    

# <a href "/my_events">Home</a> <a href "/events">Events Trending</a> <a href "/login">Login</a> <a href "/logout">Logout</a> 
