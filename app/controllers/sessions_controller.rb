class SessionsController < ApplicationController
    skip_after_action :verify_authorized, only: [:create]

    def create
        user = User.find_by(user_name: params[:username])
        

        if user&.authenticate(params[:password])
            token = JsonWebToken.encode({user_id: user.id, roles: user.roles}) # Generate JWT
            render json: { token: token, user: user, roles: user.roles }, status: :ok
        else
            render json: { error: 'Invalid email or password' }, status: :unauthorized
        end
    end
end
