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
        describe "RandomRecipes" do
            let!(:recipes) { create_list(:recipe, 10) }
            let!(:user) { create(:user) }

            let(:query) do
                <<~GRAPHQL
                    query($count: Int) {
                        randomRecipes(count: $count) {
                            id
                            name
                            image
                            servingSize
                        }
                    }
                GRAPHQL
            end

            it "returns the default number of random recipes (5)" do
                post "/api/v1/graphql", params: { query: query }

                json = JSON.parse(response.body)
                data = json["data"]["randomRecipes"]

                expect(response).to have_http_status(:ok)
                expect(data.size).to eq(5)
                expect(data.first).to include("id", "name", "image", "servingSize")
            end

            it "returns a custom number of random recipes when count is specified" do
                post "/api/v1/graphql", params: { query: query, variables: { count: 3 }.to_json }

                json = JSON.parse(response.body)
                data = json["data"]["randomRecipes"]
                puts json
                expect(response).to have_http_status(:ok)
                expect(data.size).to eq(3)
                expect(data.first).to include("id", "name", "image", "servingSize")
            end
        end
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

            it "returns errors with invalid data" do
                invalid_vars = {
                    input: {
                        firstName: "",
                        lastName: "",
                        email: "not-an-email",
                        password: "short"
                    }
                }

                post "/api/v1/graphql",
                    params: { query: mutation, variables: invalid_vars }.to_json,
                    headers: { "Content-Type" => "application/json" }

                expect(response).to have_http_status(:ok)
                json = JSON.parse(response.body)
                data = json["data"]["registerUser"]

                expect(data["user"]).to be_nil
                expect(data["token"]).to be_nil
                expect(data["errors"]).to_not be_empty
            end
        end
    end
end
