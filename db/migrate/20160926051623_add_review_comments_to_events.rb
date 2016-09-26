class AddReviewCommentsToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :review_comments, :int
  end
end
