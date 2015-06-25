class CreateUnlockedTimes < ActiveRecord::Migration
  def change
    create_table :unlocked_times do |t|
      t.date :start_time
      t.date :end_time

      t.timestamps
    end
  end
end
