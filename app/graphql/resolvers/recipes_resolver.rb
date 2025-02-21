module Resolvers
    class RecipesResolver < Resolvers::BaseResolver
        type [ Types::RecipeType ], null: false

        argument :cookbook, Boolean, required: false, description: "Filter by user cookbook"

        def resolve(cookbook: nil)
            if cookbook.nil?
                authorize(Recipe, :index?, policy_class: RecipePolicy)
                Recipe.includes(:recipe_instructions, recipe_ingredients: [:measurement, :ingredient]).all
            else
                user = context[:current_user]
                return [] unless user&.cookbook
                authorize(user.cookbook, :show?, policy_class: CookbookPolicy)
                user.cookbook.recipes.includes(:recipe_instructions, recipe_ingredients: [:measurement, :ingredient])
            end
        end
    end
end
