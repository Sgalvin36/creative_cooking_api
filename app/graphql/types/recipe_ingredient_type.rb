module Types
    class RecipeIngredientType < Types::BaseObject
        field :id, ID, null: false
        field :quantity, Float, null: false
        field :recipe, Type::RecipeType, null:false
        field :ingredient, Type::IngredientType, null:false
        field :measurement, Type::MeasurementType, null:false
    end
end