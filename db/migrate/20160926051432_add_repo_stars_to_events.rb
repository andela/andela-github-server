class AddRepoStarsToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :repo_stars, :bigint
  end
end
