module Types
    class IngredientModificationType < Types::BaseObject
        field :id, ID, null: false
        field :modified_quantity, Float, null: false
        field :ingredient, Types::IngredientType, null: false
        field :measurement, Types::MeasurementType, null: false
        field :recipe_ingredient, Types::RecipeIngredientType, null: true
    end
end
