module Resolvers
    class CookbookRecipesResolver < Resolvers::BaseResolver
        type Types::CookbookType, null: false

        description "Fetch a single cookbook (with recipes) by ID"

        argument :id, ID, required: true

        def resolve(id:)
            cookbook = Cookbook.find(id)
            Pundit.authorize(context[:current_user], cookbook, :show?)
            cookbook
        end
    end
end
