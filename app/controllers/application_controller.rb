class ApplicationController < ActionController::API
    include Pundit::Authorization
    after_action :verify_authorized
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    def verify_pundit_authorization
        if action_name == "index"
            verify_policy_scoped
        else
            verify_authorized
        end
    end

    private

    def user_not_authorized(exception)
        policy_name = exception.policy.class.to_s.underscore
    
        flash[:error] = t "#{policy_name}.#{exception.query}", scope: "pundit", default: :default
        redirect_back_or_to(root_path)
    end
end
