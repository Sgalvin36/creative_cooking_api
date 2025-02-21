module Types
    class RecipeIngredientType < Types::BaseObject
        field :id, ID, null: false
        field :quantity, Float, null: false
        field :recipe, Types::RecipeType, null: false
        field :ingredient, Types::IngredientType, null: false
        field :measurement, Types::MeasurementType, null: false
    end
end
