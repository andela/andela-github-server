require 'json'
Dir.chdir(File.dirname(__FILE__))
events = JSON.parse(File.read('../../public/archive.json')) if File.exist?('../../public/archive.json')

namespace :archive do
  desc "Populate database with github archive data"
  task populate: :environment do
      events.each do |event|
        user = User.find_or_create_by(username: event['author'])
        user_event = user.events.where(:gh_event_id => event['id'])
        if user_event.blank?
          user.events.create!(
            gh_event_id: event['id'], 
            event_type: event['type'],  
            event_created_at: event['created_at'],
            event_url: event['event_url'],
            repo_url: event['repo_url'],
            repo_stars: event['stargazers_count'],
            merged: event['merged'].to_s,
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
            merged: event['merged'].to_s,
            comments: event['comments'], 
            review_comments: event['review_comments'],
            commits_count: event['commits'],
            language: event['language']
          )
        end
      end
  end
end
