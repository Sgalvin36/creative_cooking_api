class CreateCookbookRecipes < ActiveRecord::Migration[8.0]
  def change
    create_table :cookbook_recipes do |t|
      t.boolean :tried_it
      t.references :cookbook, null: false, foreign_key: true
      t.references :recipe, null: false, foreign_key: true

      t.timestamps
    end
  end
end
