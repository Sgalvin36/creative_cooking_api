module Types
    class IngredientModificationType < Types::BaseObject
        field :id, ID, null: false
        field :modified_quantity, Float, null: false
        field :ingredient, Type::IngredientType, null:false
        field :measurement, Type::MeasurementType, null:false
        field :recipe_ingredient, Type::RecipeIngredientType, null:true
    end
end