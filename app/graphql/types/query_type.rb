# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :recipes, resolver: Resolvers::RecipesResolver
  end
end
