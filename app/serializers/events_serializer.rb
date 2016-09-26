class EventsSerializer < ActiveModel::Serializer
  attributes :gh_event_id, :event_type, :event_created_at
  attributes :repo_url, :event_url, :repo_stars
  attributes :commits_count, :comments, :review_comments, :merged
  belongs_to :user
end
