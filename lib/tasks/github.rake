require "octokit"
require 'uri'

=begin
gh = Octokit::Client.new \
  client_id: ENV['GITHUB_CLIENT_ID'], 
  client_secret: ENV['GITHUB_CLIENT_SECRET']
=end

gh = Octokit::Client.new(:access_token => ENV['GITHUB_ACCESS_TOKEN']) 

gh.auto_paginate = true

namespace :members do
  desc "Retrieve organization members"
  task retrieve: :environment do 
    members = gh.organization_members "andela", :per_page => 100
    puts "Retrieved #{members.size}"
    # unless gh.last_response.rels[:next].nil?
    #  members.concat gh.last_response.rels[:next].get.data 
    #  members.each { |member| User.find_or_create_by(username: member.login) }
    # end
    members.each { |member| User.find_or_create_by(username: member.login) }
    puts "members:retrieve done"
  end

  desc "Prune organization members"
  task prune: :environment do
    User.all.each do |user|
      puts "#{user.username} is getting pruned"
      begin 
        User.destroy(user.id) unless gh.user user.username 
      rescue Octokit::Error
        User.destroy(user.id)
        next
      end
    end
    puts "members:prune done"
  end
end

namespace :events do
  desc "Retrieve events for each organization members"
  task retrieve: :environment do
    User.all.each do |user|
      events = gh.user_events user.username, :per_page => 100
      puts "Retrieved #{events.size} events for #{user.username}"
      events.each do |event|
        next unless event.type == 'PullRequestEvent'
        user_event = user.events.where(:gh_event_id => event.id)
        if user_event.blank?
          puts "Creating new #{event.type} event for #{user.username}"
          user.events.create!(
            gh_event_id: event.id,
            event_type: event.type,
            event_created_at: event.payload.pull_request.updated_at,
            event_url: event.payload.pull_request.html_url,
            repo_url: event.payload.pull_request.base.repo.html_url,
            repo_stars: event.payload.pull_request.base.repo.stargazers_count,
            merged: gh.pull_merged?(event.repo.name, event.payload.pull_request.number).to_s,
            comments: event.payload.pull_request.comments,
            review_comments: event.payload.pull_request.review_comments,
            commits_count: event.payload.pull_request.commits,
            org: event.payload.pull_request.base.repo.login,
            language: event.payload.pull_request.base.repo.language
          )
          puts "#{event.type} on #{event.repo_url} created for #{user.username}"
        else
          puts "Updating #{event.type} event for #{user.username}"
          event.update(
            event_type: event.type,
            event_created_at: event.payload.pull_request.updated_at,
            event_url: event.payload.pull_request.html_url,
            repo_url: event.payload.pull_request.base.repo.html_url,
            repo_stars: event.payload.pull_request.base.repo.stargazers_count,
            merged: gh.pull_merged?(event.repo.name, event.payload.pull_request.number).to_s,
            comments: event.payload.pull_request.comments,
            review_comments: event.payload.pull_request.review_comments,
            commits_count: event.payload.pull_request.commits,
            org: event.payload.pull_request.base.repo.login,
            language: event.payload.pull_request.base.repo.language
          )
        end
      end
    end
    puts "events:retrieve done"
  end

  desc "Update event statuses"
  task update: :environment do
    User.all.each do |user|
      puts "Looking up #{user.username}"
      user.events.each do |event|
        puts "Updaing #{event.repo_url} for #{user.username}"
        repo = URI.parse(event.repo_url).path.match(/(?<=\/).+/).to_s
        pr = event.event_url.match(/(\d)*\Z/).captures.join
        event.update_attribute(:merged, gh.pull_merged?(repo, pr).to_s)
      end
    end
    puts "events:update done"
  end
end
