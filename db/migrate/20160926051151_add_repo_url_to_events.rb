class AddRepoUrlToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :repo_url, :string
  end
end
