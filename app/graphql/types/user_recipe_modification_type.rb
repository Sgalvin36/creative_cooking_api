module Types
    class UserRecipeModificationType < Types::BaseObject
        field :id, ID, null: false
        field :user, Types::UserType, null: false
        field :recipe, Types::RecipeType, null: false
        field :ingredient_modifications, [ Types::IngredientModificationType ], null: false
    end
end
