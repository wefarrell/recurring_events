class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.references :recurring_event, foreign_key: true
      t.time :start_time, null: false
      t.date :date, null: false
      t.integer :duration_minutes, null: false
      t.string :name, null: false
      t.timestamps
    end
  end
end
