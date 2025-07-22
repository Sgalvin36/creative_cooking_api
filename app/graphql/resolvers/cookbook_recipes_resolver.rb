module Resolvers
    class CookbookRecipesResolver < Resolvers::BaseResolver
        type [ Types::RecipeType ], null: false

        def resolve
            user = context[:current_user]
            return [] unless user&.cookbook
            authorize(user.cookbook, :show?, policy_class: CookbookPolicy)
            user.cookbook.recipes
        end
    end
end
