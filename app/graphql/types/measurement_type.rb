module Types
    class MeasurementType < Types::BaseObject
        field :id, ID, null: false
        field :unit, String, null: false
        field :recipe_ingredients, [Type::RecipeIngredientType], null:true
    end
end
