class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.bigint :gh_event_id
      t.string :event_type
      t.json :payload
      t.boolean :public
      t.datetime :event_created_at
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
