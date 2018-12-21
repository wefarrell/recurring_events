class CreateRecurringEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :recurring_events do |t|
      t.integer :frequency, null: false
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.time :start_time, null: false
      t.integer :duration_minutes, null: false
      t.string :name
      t.timestamps
    end
  end
end
