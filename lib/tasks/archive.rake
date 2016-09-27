require 'json'
require 'pry'
Dir.chdir(File.dirname(__FILE__))
# events = IO.readlines('../../public/results.json')

namespace :archive do
  desc "Populate database with github archive data"
  task populate: :environment do
      events.each do |event|
        event = JSON.parse(event)
        user = User.find_or_create_by(username: event['actor_login'])
        user_event = user.events.where(:gh_event_id => event['id'])
        binding.pry
        if user_event.blank?
          user.events.create!(
            gh_event_id: event['id'], 
            event_type: event['type'],  
            event_created_at: event['created_at'],
            event_url: event['event_url'],
            repo_url: event['repo_url'],
            repo_stars: event['stargazers_count'],
            merged: event['merged'],
            comments: event['comments'], 
            review_comments: event['review_comments'],
            commits_count: event['commits'],
            language: event['language']
          )
        else 
          user_event.update(
            event_type: event['type'],  
            event_created_at: event['created_at'],
            event_url: event['event_url'],
            repo_url: event['repo_url'],
            repo_stars: event['stargazers_count'],
            merged: event['merged'],
            comments: event['comments'], 
            review_comments: event['review_comments'],
            commits_count: event['commits'],
            language: event['language']
          )
        end
      end
  end
end
