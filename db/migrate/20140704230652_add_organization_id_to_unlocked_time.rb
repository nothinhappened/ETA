class AddOrganizationIdToUnlockedTime < ActiveRecord::Migration
  def change
    add_column :unlocked_times, :organization_id, :integer, {null: false, default:-1}
  end
end
