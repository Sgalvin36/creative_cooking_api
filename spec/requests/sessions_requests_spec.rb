require 'rails_helper'

RSpec.describe "Sessions Controller", type: :request do
    let!(:user) { create(:user) }
    let!(:cookbook1) { create(:cookbook, user: user) }
    let!(:cookbook2) { create(:cookbook, user: user) }

    describe "POST /api/v1/login" do
        context "When user attempts to login" do
            it "logs in a user with valid email and password" do
                post "/api/v1/login", params: { email: user.email, password: "Passwords123!" }

                expect(response).to have_http_status(:ok)
                expect(JSON.parse(response.body)).to include("user")
                expect(JSON.parse(response.body)).not_to include("token")

                set_cookie_header = response.headers["Set-Cookie"]
                expect(set_cookie_header).to include("jwt=")
                expect(set_cookie_header).to include("httponly")
                expect(set_cookie_header).to include("samesite=lax")
                expect(set_cookie_header).to include("Secure") if Rails.env.production?
            end

            it "logs in a user with valid username and password" do
                post "/api/v1/login", params: { username: user.user_name, password: "Passwords123!" }

                expect(response).to have_http_status(:ok)
                expect(JSON.parse(response.body)).to include("user")
                expect(JSON.parse(response.body)).not_to include("token")

                set_cookie_header = response.headers["Set-Cookie"]
                expect(set_cookie_header).to include("jwt=")
                expect(set_cookie_header).to include("httponly")
                expect(set_cookie_header).to include("samesite=lax")
                expect(set_cookie_header).to include("Secure") if Rails.env.production?
            end

            it "rejects login with wrong password" do
                post "/api/v1/login", params: { email: user.email, password: "wrongpass" }

                expect(response).to have_http_status(:unauthorized)
                expect(JSON.parse(response.body)).to include("error")
            end

            it "rejects login with wrong password" do
                post "/api/v1/login", params: { username: user.user_name, password: "wrongpass" }

                expect(response).to have_http_status(:unauthorized)
                expect(JSON.parse(response.body)).to include("error")
            end

            it "returns a valid JSON response with primary_cookbook_id and cookbook_count" do
                post "/api/v1/login", params: { email: user.email, password: "Passwords123!" }

                expect(response).to have_http_status(:ok)

                json = JSON.parse(response.body)

                # Check keys exist
                expect(json).to include("user", "roles")

                user_data = json["user"]

                expect(user_data).to include(
                    "id",
                    "first_name",
                    "last_name",
                    "username",
                    "slug",
                    "primary_cookbook_id",
                    "cookbook_count"
                )

                expect(user_data["id"]).to be_a(Integer)
                expect(user_data["first_name"]).to be_a(String)
                expect(user_data["last_name"]).to be_a(String)
                expect(user_data["username"]).to be_a(String)
                expect(user_data["slug"]).to be_a(String)
                expect(user_data["primary_cookbook_id"]).to be_a(Integer).or be_nil
                expect(user_data["cookbook_count"]).to eq(3)
            end

            context "when user has no cookbooks" do
                let!(:user_without_cookbooks) { create(:user) }

                let(:params) do
                    {
                        username: user_without_cookbooks.user_name,
                        password: user_without_cookbooks.password
                    }
                end

                it "returns nil for primary_cookbook_id and zero for cookbook_count" do
                    Cookbook.where(user_id: user_without_cookbooks.id).delete_all
                    post "/api/v1/login", params: params

                    expect(response).to have_http_status(:ok)
                    json = JSON.parse(response.body)
                    user_data = json["user"]

                    expect(user_data["primary_cookbook_id"]).to be_nil
                    expect(user_data["cookbook_count"]).to eq(0)
                end
            end
        end
    end

    describe "DELETE /api/v1/logout" do
        context "When user attempts to logout" do
            let(:token) { JsonWebToken.encode(user_id: user.id) }

            before do
                headers = { "Cookie" => "jwt=#{token}" }
                @headers = headers
            end

            it "successfully deletes the cookie and logs the user out" do
                delete "/api/v1/logout", headers: @headers, params: {}, as: :json

                expect(response).to have_http_status(:no_content)

                set_cookie_header = response.headers["Set-Cookie"]
                expect(set_cookie_header).to include("jwt=;")
                expect(set_cookie_header).to include("expires=")
            end

            it "returns bad request if no cookie is present" do
                delete "/api/v1/logout"

                expect(response).to have_http_status(:bad_request)
                expect(JSON.parse(response.body)).to include("error" => "No session found")
            end
        end
    end

    describe "GET /api/v1/me" do
        context "When jwt cookie is present" do
            let(:token) { JsonWebToken.encode(user_id: user.id) }

            before do
                headers = { "Cookie" => "jwt=#{token}" }
                @headers = headers
            end

            it "returns current user and their roles" do
                get "/api/v1/me", headers: @headers, params: {}, as: :json

                expect(response).to have_http_status(:ok)

                data = JSON.parse(response.body)

                expect(data).to include("user", "roles")

                user_data = data["user"]

                expect(user_data).to include(
                    "id",
                    "first_name",
                    "last_name",
                    "username",
                    "slug",
                    "primary_cookbook_id",
                    "cookbook_count"
                )

                expect(user_data["id"]).to be_a(Integer)
                expect(user_data["first_name"]).to be_a(String)
                expect(user_data["last_name"]).to be_a(String)
                expect(user_data["username"]).to be_a(String)
                expect(user_data["slug"]).to be_a(String)
                expect(user_data["primary_cookbook_id"]).to be_a(Integer).or be_nil
                expect(user_data["cookbook_count"]).to eq(3)
            end
        end

        context "When jwt cookie is not present" do
            it "returns unauthorized with user: nil" do
                get "/api/v1/me"

                expect(response).to have_http_status(:unauthorized)

                data = JSON.parse(response.body)
                expect(parsed).to eq({ "user" => nil })
            end
        end

        context "when jwt cookie is invalid or expired" do
            let(:token) { "not-a-valid-token" }

            before do
                headers = { "Cookie" => "jwt=#{token}" }
                @headers = headers
            end

            it "returns unauthorized with user: nil" do
                get "/api/v1/me", headers: @headers, params: {}, as: :json

                expect(response).to have_http_status(:unauthorized)

                data = JSON.parse(response.body)
                expect(data).to eq({ "user" => nil })
            end
        end
    end
end
