class RemovePublicFromEvents < ActiveRecord::Migration[5.0]
  def change
    remove_column :events, :public, :boolean
  end
end
