class CreateStats < ActiveRecord::Migration[5.0]
  def change
    create_table :stats do |t|
      t.string :event_type
      t.integer :commits_count
      t.bigint :additions_count
      t.bigint :deletions_count
      t.string :repo_name
      t.string :html_url
      t.string :language
      t.datetime :event_created_at

      t.timestamps
    end
  end
end
