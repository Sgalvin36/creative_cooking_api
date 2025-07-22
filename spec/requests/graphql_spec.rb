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

                expect(response).to have_http_status(:ok)
                expect(data.size).to eq(3)
                expect(data.first).to include("id", "name", "image", "servingSize")
            end

            it "returns the default number of random recipes when count is out of range (< 1)" do
                post "/api/v1/graphql", params: { query: query, variables: { count: -4 }.to_json }

                json = JSON.parse(response.body)
                data = json["data"]["randomRecipes"]

                expect(response).to have_http_status(:ok)
                expect(data.size).to eq(5)
                expect(data.first).to include("id", "name", "image", "servingSize")
            end

            it "returns the default number of random recipes when count is nil" do
                post "/api/v1/graphql", params: { query: query, variables: { count: nil }.to_json }

                json = JSON.parse(response.body)
                data = json["data"]["randomRecipes"]

                expect(response).to have_http_status(:ok)
                expect(data.size).to eq(5)
                expect(data.first).to include("id", "name", "image", "servingSize")
            end
        end

        describe "OneRecipe" do
            let!(:recipe) { create(:recipe, serving_size: 4, image: "http://example.com/image.jpg") }
            let!(:instruction) { create(:recipe_instruction, recipe: recipe, instruction_step: 1, instruction: "Do something") }
            let!(:ingredient) { create(:ingredient) }
            let!(:measurement) { create(:measurement) }
            let!(:recipe_ingredient) do
                create(:recipe_ingredient, recipe: recipe, ingredient: ingredient, measurement: measurement)
            end

            let(:query) do
                <<~GRAPHQL
                    query($id: ID!) {
                        oneRecipe(id: $id) {
                            id
                            name
                            image
                            servingSize
                            recipeInstructions {
                                instructionStep
                                instruction
                            }
                            recipeIngredients {
                                quantity
                                measurement {
                                    unit
                                }
                                ingredient {
                                    name
                                }
                            }
                        }
                    }
                GRAPHQL
            end

            it "returns the full recipe with all associated data" do
                post "/api/v1/graphql",
                    params: {
                        query: query,
                        variables: { id: recipe.id }.to_json
                    }

                json = JSON.parse(response.body)
                data = json["data"]["oneRecipe"]

                expect(response).to have_http_status(:ok)
                expect(data["id"]).to eq(recipe.id.to_s)
                expect(data["name"]).to eq(recipe.name)
                expect(data["image"]).to eq(recipe.image)
                expect(data["servingSize"]).to eq(recipe.serving_size)
                expect(data["recipeInstructions"].first["instructionStep"]).to eq(instruction.instruction_step)
                expect(data["recipeInstructions"].first["instruction"]).to eq(instruction.instruction)
                ingredient_data = data["recipeIngredients"].first
                expect(ingredient_data["quantity"]).to eq(recipe_ingredient.quantity)
                expect(ingredient_data["measurement"]["unit"]).to eq(measurement.unit)
                expect(ingredient_data["ingredient"]["name"]).to eq(ingredient.name)
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
