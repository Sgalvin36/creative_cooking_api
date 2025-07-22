module Resolvers
    class PublicCookbooksResolver < Resolvers::BaseResolver
        type [ Types::CookbookType ], null: false

        description "Returns all cookbooks that have been marked as public and are visible to anyone"

        def resolve
            Pundit.policy_scope!(context[:current_user], Cookbook).order(:cookbook_name)
        end
    end
end
