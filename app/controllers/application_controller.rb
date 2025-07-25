class ApplicationController < ActionController::API
    include ActionController::Cookies
    include Pundit::Authorization
    before_action :set_current_user
    after_action :verify_authorized
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    def verify_pundit_authorization
        if action_name == "index"
            verify_policy_scoped
        else
            verify_authorized
        end
    end

    def set_current_user
        token = request.headers["Authorization"]&.split(" ")&.last
        if token
            decoded_token = JsonWebToken.decode(token)
            @current_user = User.find_by(id: decoded_token&.dig("user_id"))
        end
    end

    def current_user
        @current_user
    end

    private

    def user_not_authorized(exception)
        policy_name = exception.policy.class.to_s.underscore

        flash[:error] = t "#{policy_name}.#{exception.query}", scope: "pundit", default: :default
        redirect_back_or_to(root_path)
    end
end
