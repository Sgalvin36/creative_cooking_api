class AddPublicToCookbooks < ActiveRecord::Migration[8.0]
  def change
    add_column :cookbooks, :public, :boolean, default: true, null: false
  end
end
