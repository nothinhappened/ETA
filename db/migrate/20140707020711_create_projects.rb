class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :title
      t.text :description

      # id references
      t.integer :organization_id

      t.timestamps
    end

    add_index :projects, [:organization_id]
  end
end
