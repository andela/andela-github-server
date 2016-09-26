class AddMergedToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :merged, :string
  end
end
