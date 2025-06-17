# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
      field :personal_cookbook, resolver: Resolvers::PersonalCookbookResolver
      field :random_recipes, resolver: Resolvers::RandomRecipesResolver
      field :all_recipes, resolver: Resolvers::AllRecipesResolver
      field :one_recipe, resolver: Resolvers::OneRecipeResolver
  end
end
