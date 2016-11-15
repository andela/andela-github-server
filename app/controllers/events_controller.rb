class EventsController < ApplicationController
  def index
    @events = Event.where.not("repo_url like ?", "%andela%").where("repo_stars >= 2").where(merged: 'true')
    @top_event = Event.where.not("repo_url like ?", "%andela%").where("repo_stars >= 30").where(merged: "true").order(event_created_at: :desc).first
    last_updated = @top_event.event_created_at
    last_updated_link = @top_event.event_url
    last_update_made_by = @top_event.user.username
    commits = @events.sum(:commits_count)
    merged = @events.pluck(:repo_url).size
    contributors = @events.distinct.pluck(:user_id).size
    review_comments = @events.sum(:review_comments)
    languages = @events.where('language IS NOT NULL').group(:language).size 
    projects = @events.distinct.pluck(:repo_url).size
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
