class AddCommitsCountToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :commits_count, :int
  end
end
