class CreateCookbookTags < ActiveRecord::Migration[8.0]
  def change
    create_table :cookbook_tags do |t|
      t.references :cookbook, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end
  end
end
