class EventsController < ApplicationController
  def index
    last_updated = Event.order('event_created_at ASC').first.event_created_at
    commits = Event.sum(:commits_count)
    merged = Event.where(merged: 't').size
    review_comments = Event.sum(:review_comments)
    languages = Event.where('language IS NOT NULL').group(:language).size 
    commits_by_language = Event.group(:language).sum(:commits_count) 
    render json: { 
      last_updated: last_updated, 
      stats: { 
        commits: commits,
        merged: merged,
        review_comments: review_comments,
        commits_by_language: commits_by_language
      },
      contributions: {
        languages: languages 
      }
    }, serializer: nil
  end

  def show 
    @user = User.find_by_username(params[:username]) if params[:username]
    render json: @user.events
  end

  def all 
    render json: Event.all
  end

end
