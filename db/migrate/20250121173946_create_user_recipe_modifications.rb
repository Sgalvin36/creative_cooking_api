class CreateUserRecipeModifications < ActiveRecord::Migration[8.0]
  def change
    create_table :user_recipe_modifications do |t|
      t.references :user, null: false, foreign_key: true
      t.references :recipe, null: false, foreign_key: true

      t.timestamps
    end
  end
end
