# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
      field :random_recipes, resolver: Resolvers::RandomRecipesResolver, description: "Fetch random number of recipes with option to specify how many"

      field :all_recipes, resolver: Resolvers::AllRecipesResolver, description: "Fetch all recipes, with search options available"

      field :one_recipe, resolver: Resolvers::OneRecipeResolver, description: "Fetch all data for one recipe including ingredients and steps"

      field :user_cookbooks, resolver: Resolvers::UserCookbooksResolver, description: "Fetch all cookbooks created by the currently signed-in user"

      field :public_cookbooks, resolver: Resolvers::AllPublicCookbooksResolver, description: "Fetch all public cookbooks in database"

      field :cookbook_recipes, resolver: Resolvers::CookbookRecipesResolver, description: "Fetch all recipes from a specific cookbook ID. Must be public or owned by user."
  end
end
