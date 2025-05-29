module Resolvers
    class RandomRecipesResolver < Resolvers::BaseResolver
        type [Types::RecipeType], null: false

        argument :count, Integer, required: false, default_value: 5, description: "Number of random recipes to return"

        def resolve(count:)
            authorize(Recipe, :index?, policy_class: RecipePolicy)
            # Randomly select `count` recipes. The exact method depends on your DB adapter.
            Recipe.order("RANDOM()").limit(count)
        end
    end
end