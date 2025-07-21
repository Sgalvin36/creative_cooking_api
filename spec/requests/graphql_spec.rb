require 'rails_helper'

RSpec.describe "GraphQL API", type: :request do
    let(:user) { create(:user) }
    let(:login_params) do
        {
            email: user.email,
            password: user.password
        }
    end

    let(:auth_token) do
        post "/api/v1/login", params: login_params
        JSON.parse(response.body)["token"]
    end

    let(:headers) do
        {
            "Authorization" => "Bearer #{auth_token}",
            "Content-Type" => "application/json"
        }
    end

    describe "Queries" do
    end

    describe "Mutations" do
        describe "RegisterUser" do
            let(:mutation) do
                <<~GRAPHQL
                    mutation RegisterUser($input: RegisterUserInput!) {
                        registerUser(input: $input) {
                            user {
                                id
                                firstName
                                lastName
                                email
                            }
                            token
                            errors
                        }
                    }
                GRAPHQL
            end

            let(:variables) do
                {
                    input: {
                        firstName: "Test",
                        lastName: "User",
                        email: "testUser@example.com",
                        password: "Password123!"
                    }
                }
            end

            it "registers a new user successfully" do
                post "/api/v1/graphql",
                    params: { query: mutation, variables: variables }.to_json,
                    headers: { "Content-Type" => "application/json" }

                expect(response).to have_http_status(:ok)
                json = JSON.parse(response.body)
                data = json["data"]["registerUser"]

                expect(data["user"]["email"]).to eq("testUser@example.com")
                expect(data["token"]).to be_present
                expect(data["errors"]).to be_empty
            end
        end
    end
end
