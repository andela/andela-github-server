class AddOrgToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :org, :string
  end
end
