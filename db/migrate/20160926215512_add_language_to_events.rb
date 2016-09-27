class AddLanguageToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :language, :string
  end
end
