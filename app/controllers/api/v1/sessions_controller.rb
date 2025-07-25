class Api::V1::SessionsController < ApplicationController
    skip_after_action :verify_authorized, only: [ :create, :destroy ]

    def create
        identifier = params[:username] || params[:email]
        user = User.find_by("user_name = :identifier OR email = :identifier", identifier: identifier)



        if user&.authenticate(params[:password])
            token = JsonWebToken.encode({ user_id: user.id, roles: user.roles }) # Generate JWT

            cookies.signed[:jwt] = {
                value: token,
                httponly: true,
                secure: Rails.env.production?,
                same_site: :lax
            }
            render json: {
                user: {
                    id: user.id,
                    first_name: user.first_name,
                    last_name: user.last_name,
                    username: user.user_name,
                    slug: user.slug,
                    primary_cookbook_id: user.cookbooks[0]&.id,
                    cookbook_count: user.cookbooks.count
                },
                roles: user.roles
            }, status: :ok
        else
            sleep 0.5 # a way to slow down brute force attempts
            render json: { error: "Invalid credentials" }, status: :unauthorized
        end
    end

    def destroy
        if cookies[:jwt].present?
            cookies.delete(:jwt, httponly: true, secure: Rails.env.production?, same_site: :lax)
            head :no_content
        else
            render json: { error: "No session found" }, status: :bad_request
        end
    end
end
