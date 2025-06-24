class Api::V1::SessionsController < ApplicationController
    skip_after_action :verify_authorized, only: [ :create ]

    def create
        identifier = params[:username] || params[:email]
        user = User.find_by("user_name = :identifier OR email = :identifier", identifier: identifier)



        if user&.authenticate(params[:password])
            token = JsonWebToken.encode({ user_id: user.id, roles: user.roles }) # Generate JWT
            render json: {
                token: token,
                user: {
                    id: user.id,
                    first_name: user.first_name,
                    last_name: user.last_name,
                    user_name: user.user_name,
                    slug: user.slug
                },
                roles: user.roles
            }, status: :ok
        else
            render json: { error: "Invalid email or password" }, status: :unauthorized
        end
    end
end
