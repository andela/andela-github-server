require "octokit"

gh = Octokit::Client.new(:access_token => '7e561ebee894c52c7bcaa7a40616ba697a3845d3')
gh.auto_paginate = true

namespace :github do
  desc "Retrieve github data and store"
  members = gh.organization_members "andela"
  task retrieve: :environment do
    members.each do |member| 
      user = User.find_or_create_by(username: member.login)    
      events = gh.user_events user.username 
      events.each do |event| 
        next unless event.type == 'PullRequestEvent'
        user_event = user.events.where(:gh_event_id => event.id)
        if user_event.blank?
          user.events.create!(
            gh_event_id: event.id, 
            event_type: event.type,  
            event_created_at: event.created_at,
            event_url: event.payload.pull_request.url,
            repo_url: event.payload.pull_request.base.repo.html_url,
            repo_stars: event.payload.pull_request.base.repo.stargazers_count,
            merged: event.payload.pull_request.merged,
            comments: event.payload.pull_request.comments, 
            review_comments: event.payload.pull_request.review_comments,
            commits_count: event.payload.pull_request.commits,
            language: event.payload.pull_request.base.repo.language
          )
        else
          user_event.update(
            event_type: event.type,  
            event_created_at: event.created_at,
            event_url: event.payload.pull_request.url,
            repo_url: event.payload.pull_request.base.repo.html_url,
            repo_stars: event.payload.pull_request.base.repo.stargazers_count,
            merged: event.payload.pull_request.merged,
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
end

