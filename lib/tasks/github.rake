require "octokit"
require 'uri'

gh = Octokit::Client.new \
  client_id: ENV['GITHUB_CLIENT_ID'], 
  client_secret: ENV['GITHUB_CLIENT_SECRET']

# gh.auto_paginate = true

namespace :github do
  desc "Retrieve github data and store"
  members = gh.organization_members "andela", :per_page => 100
  task retrieve: :environment do
    members.each do |member|
      user = User.find_or_create_by(username: member.login)
      events = gh.user_events user.username, :per_page => 100
      events.each do |event|
        next unless event.type == 'PullRequestEvent'
        user_event = user.events.where(:gh_event_id => event.id)
        if user_event.blank?
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
        else
          user_event.update(
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
  end

  task retrieve_events: :environment do
    User.all.each do |user|
      events = gh.user_events user.username, :per_page => 100
      binding.pry
      events.each do |event|
        next unless event.type == 'PullRequestEvent'
        user_event = user.events.where(:gh_event_id => event.id)
        if user_event.blank?
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
        else
          user_event.update(
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
  end

  task update_pull_status: :environment do
    User.all.each do |user|
      user.events.each do |event|
        repo = URI.parse(event.repo_url).path.match(/(?<=\/).+/).to_s
        pr = event.event_url.match(/(\d)*\Z/).captures.join
        event.update_attribute(:merged, gh.pull_merged?(repo, pr).to_s)
      end
    end
  end
end
