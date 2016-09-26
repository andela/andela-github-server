class EventsController < ApplicationController
  def index
    render json: Event.all 
  end

  def show
    @events = Event.where(event_type: params[:event_type])
    render json: @events 
  end
end
