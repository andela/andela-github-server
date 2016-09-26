namespace :stats do
  desc "Update stats from events"
  task update: :environment do
    Event.all.each do |event|
      next if Stat.find_by(gh_event_id: event.gh_event_id)
      next unless event.event_type == 'PullRequestEvent'
      next unless event.payload[0][1] == 'closed'
      Stat.create!(
        gh_event_id: event.gh_event_id, 
        event_type: event.event_type,
        event_created_at: event.event_created_at, 
        commits_count: event.payload[2][1][34][1],
        additions_count: event.payload[2][1][35][1],
        deletions_count: event.payload[2][1][36][1],
        repo_name: event.payload[2][1][26][1][4][1][1][1], 
        html_url: event.payload[2][1][2][1],
        language: event.payload[2][1][26][1][4][1][56][1]
      )
    end
  end

end
