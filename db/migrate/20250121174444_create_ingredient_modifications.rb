class CreateIngredientModifications < ActiveRecord::Migration[8.0]
  def change
    create_table :ingredient_modifications do |t|
      t.float :modified_quantity
      t.references :recipe_ingredient, null: false, foreign_key: true
      t.references :ingredient, null: false, foreign_key: true
      t.references :measurement, null: false, foreign_key: true
      t.references :user_recipe_modification, null: false, foreign_key: true

      t.timestamps
    end
  end
end
