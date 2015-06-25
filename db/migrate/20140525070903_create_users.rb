class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name

      # 0 is non-user
      # 1 is admin
      # 2 is normal user      
      #t.boolean :user_type,              default:0

      # id references
      t.integer :organization_id


      # This stuff is the user login information..
      # We need to export this out into a different create table.
      t.string :email,               null: false, default: ""
      t.string :password_digest,     null: false, default: ""
      # remember token is user for sesion management
      t.string :remember_token

      t.timestamps
    end

	 add_index :users, :email,                unique: true	 
	 add_index :users, :remember_token
  end
end