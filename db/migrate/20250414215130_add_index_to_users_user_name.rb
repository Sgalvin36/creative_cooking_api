class AddIndexToUsersUserName < ActiveRecord::Migration[8.0]
  def change
    add_index :users, "LOWER(user_name)", unique: true, name: "index_users_on_lower_user_name"
  end
end
