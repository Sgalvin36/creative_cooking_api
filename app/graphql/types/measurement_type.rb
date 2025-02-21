module Types
    class MeasurementType < Types::BaseObject
        field :id, ID, null: false
        field :unit, String, null: false
        field :recipe_ingredients, [ Types::RecipeIngredientType ], null: true
    end
end
