# frozen_string_literal: true

module Mutations
  class BaseMutation < GraphQL::Schema::RelayClassicMutation
    include Pundit

    argument_class Types::BaseArgument
    field_class Types::BaseField
    input_object_class Types::BaseInputObject
    object_class Types::BaseObject
  
    private

    def authorize!(record, query = nil, policy_class: nil)
      user = context[:current_user]
      raise GraphQL::ExecutionError, "Unauthorized" unless user

      # Pundit's authorize method (uses context user)
      authorize(record, query, policy_class: policy_class)
    end
  end
end
