class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name, :limit => 32
      t.string :email, :limit => 50
      t.string :username, :limit => 24
      t.string :gender, :limit => 20
      t.date   :birthdate
      t.string :avatar
      t.string :time_zone
      t.string :password_digest
      t.string :remember_token
      t.string :auth_token
      t.string :validation_token
      t.string :password_reset_token
      t.string :email_validation_token
      t.datetime :password_reset_sent_at
      t.string :ip_address_created
      t.string :ip_address_last_modified
      t.string :ip_address_last_login
      t.boolean :email_validated, default: false
      t.datetime :email_validated_at
      t.datetime :email_changed_at
      t.boolean  :admin,           default: false
      t.datetime :last_login_at

      t.timestamps
    end

    add_index :users, :email 
    add_index :users, :username 
    add_index :users, :remember_token

  end
end
