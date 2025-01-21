class CreateRecipeInstructions < ActiveRecord::Migration[8.0]
  def change
    create_table :recipe_instructions do |t|
      t.integer :instruction_step
      t.string :instruction
      t.references :recipe, null: false, foreign_key: true

      t.timestamps
    end
  end
end
