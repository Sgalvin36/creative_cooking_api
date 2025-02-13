# frozen_string_literal: true

module Resolvers
  class BaseResolver < GraphQL::Schema::Resolver
    include Pundit::Authorization

    def authorize(record, query, policy_class: nil)
        Pundit.authorize(context[:current_user], record, query, policy_class:policy_class)
    end
  end
end
