class EventsController < ApplicationController
  def index
    @events = Event.where.not("repo_url like ?", "%andela%").where("repo_stars >= 2").where(merged: 't')
    last_updated = @events.order('event_created_at DESC').first.event_created_at
    last_updated_link = @events.order('event_created_at DESC').first.event_url
    last_update_made_by = @events.order('event_created_at DESC').first.user.username
    commits = @events.sum(:commits_count)
    merged = @events.pluck(:repo_url).size
    contributors = @events.uniq.pluck(:user_id).size
    review_comments = @events.sum(:review_comments)
    languages = @events.where('language IS NOT NULL').group(:language).size 
    projects = @events.uniq.pluck(:repo_url).size
    commits_by_language = @events.group(:language).sum(:commits_count) 
    render json: { 
      last_updated: last_updated, 
      last_updated_link: last_updated_link,
      last_update_made_by: last_update_made_by,
      stats: { 
        commits: commits,
        merged: merged,
        projects: projects,
        contributors: contributors,
        review_comments: review_comments,
        commits_by_language: commits_by_language
      },
      contributions: {
        languages: languages 
      }
    }, serializer: nil
  end
end
