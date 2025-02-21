module Types
    class IngredientType < Types::BaseObject
        field :id, ID, null: false
        field :name, String, null: false
        field :recipe_ingredients, [ Types::RecipeIngredientType ], null: false
    end
end
