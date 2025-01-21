class CreateCookbooks < ActiveRecord::Migration[8.0]
  def change
    create_table :cookbooks do |t|
      t.string :cookbook_name
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
