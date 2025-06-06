module Resolvers
    class OneRecipeResolver < Resolvers::BaseResolver
        type [ Types::RecipeType ], null: false

        argument :id, ID, required: true, description: "ID of the recipe"

        def resolve(id:)
            recipe = Recipes.includes(:recipe_instructions, recipe_ingredients: [:measurement, :ingredient]).find(id)
            authorize(recipe, :show?, policy_class: RecipePolicy)
            recipe
        end
    end
end