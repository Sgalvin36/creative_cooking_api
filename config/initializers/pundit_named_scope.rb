module Pundit
    def self.policy_scope!(user, scope)
        if scope.is_a?(Array)
            scope_name, model = scope
            scope_class_name = "#{model}Policy::#{scope_name.to_s.camelize}Scope"
            scope_class = scope_class_name.constantize
            scope_class.new(user, model.all).resolve
        else
            policy_scope = policy_scope(user, scope)
            raise NotDefinedError, "unable to find policy scope for #{scope}" unless policy_scope
            policy_scope
        end
    end
end
