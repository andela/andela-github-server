class RemovePayloadFromEvents < ActiveRecord::Migration[5.0]
  def change
    remove_column :events, :payload, :json
  end
end
