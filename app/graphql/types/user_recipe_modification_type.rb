module Types
    class UserRecipeModificationType < Types::BaseObject
        field :id, ID, null: false
        field :user, Type::UserType, null: false
        field :recipe, Type::RecipeType, null:false
        field :ingredient_modifications, [Type::IngredientModificationType], null:false
    end
end