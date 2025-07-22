module Resolvers
    class UserCookbooksResolver < Resolvers::BaseResolver
        type [ Types::RecipeType ], null: false

        description "Return only the user's public and private cookbooks"

        def resolve
            Pundit.policy_scope!(context[:current_user], [ :owned, Cookbook ]).order(:cookbook_name)
        end
    end
end
