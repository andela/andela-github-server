class AddCommentsToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :comments, :int
  end
end
