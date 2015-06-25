class AddColumnOrganizationNameToOrganization < ActiveRecord::Migration
  def change
    add_column :organizations, :organization_name, :text
  end
end
