module Resolvers
    class AllRecipesResolver < Resolvers::BaseResolver
        type [Types::RecipeType], null: false

    # Optional arguments for filtering, pagination, etc., can be added here
        argument :search, String, required: false, description: "Search recipes by name or description"
        argument :limit, Integer, required: false, description: "Limit the number of recipes returned"
        argument :offset, Integer, required: false, description: "Offset for pagination"

        def resolve(search: nil, limit: 20, offset: 0)
            authorize(Recipe, :index?, policy_class: RecipePolicy)

            recipes = Recipe.includes(:recipe_instructions, recipe_ingredients: [:measurement, :ingredient])
                            .order(created_at: :desc)

            if search.present?
                recipes = recipes.where("name ILIKE :search OR description ILIKE :search", search: "%#{search}%")
            end

            recipes.limit(limit).offset(offset)
        end
    end
end