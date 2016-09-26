class AddGhEventIdToStats < ActiveRecord::Migration[5.0]
  def change
    add_column :stats, :gh_event_id, :bigint
  end
end
