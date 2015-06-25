class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.string :description

      # id references
      t.integer :organization_id

      t.timestamps
    end

    add_index :tasks, [:organization_id]
  end
end
