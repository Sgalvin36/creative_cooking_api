require 'rails_helper'

RSpec.describe "GraphQL API", type: :request do
    let(:user) { create(:user) }
    let(:admin) { create(:user, :admin) }


    def auth_headers(user = nil)
        if user
            token = JsonWebToken.encode(user_id: user.id)
            {
                "Authorization" => "Bearer #{token}",
                "Content-Type" => "application/json"
            }
        else
            { "Content-Type" => "application/json" }
        end
    end

    describe "Queries" do
        describe "RandomRecipes" do
            let!(:recipes) { create_list(:recipe, 10) }

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
                post api_v1_graphql_path, params: { query: query }.to_json, headers: auth_headers(nil)

                json = JSON.parse(response.body)
                data = json["data"]["randomRecipes"]

                expect(response).to have_http_status(:ok)
                expect(data.size).to eq(5)
                expect(data.first).to include("id", "name", "image", "servingSize")
            end

            it "returns a custom number of random recipes when count is specified" do
                post api_v1_graphql_path, params: { query: query, variables: { count: 3 } }.to_json, headers: auth_headers(nil)
                json = JSON.parse(response.body)
                data = json["data"]["randomRecipes"]

                expect(response).to have_http_status(:ok)
                expect(data.size).to eq(3)
                expect(data.first).to include("id", "name", "image", "servingSize")
            end

            it "returns the default number of random recipes when count is out of range (< 1)" do
                post api_v1_graphql_path, params: { query: query, variables: { count: -4 } }.to_json, headers: auth_headers(nil)

                json = JSON.parse(response.body)
                data = json["data"]["randomRecipes"]

                expect(response).to have_http_status(:ok)
                expect(data.size).to eq(5)
                expect(data.first).to include("id", "name", "image", "servingSize")
            end

            it "returns the default number of random recipes when count is nil" do
                post api_v1_graphql_path, params: { query: query, variables: { count: nil } }.to_json, headers: auth_headers(nil)

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
                post api_v1_graphql_path, params: { query: query, variables: { id: recipe.id } }.to_json, headers: auth_headers(nil)

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

        describe "publicCookbooks" do
            let!(:public_cookbooks) { create_list(:user, 3) } # auto generates users initial cookbook as public
            let!(:user_private_cookbook) { create(:cookbook, user: user, public: false) }
            let!(:admin_private_cookbook) { create(:cookbook, user: admin, public: false) }

            let(:query) do
                <<~GRAPHQL
                    query {
                        publicCookbooks {
                            id
                            cookbookName
                            public
                            user {
                                id
                            }
                        }
                    }
                GRAPHQL
            end

            context "when no user is logged in" do
                it "returns only public cookbooks" do
                    post api_v1_graphql_path, params: { query: query }.to_json, headers: auth_headers(nil)

                    json = JSON.parse(response.body)
                    data = json["data"]["publicCookbooks"]

                    expect(response).to have_http_status(:ok)
                    expect(data.count).to eq(5)
                    expect(data.all? { |cb| cb["public"] == true }).to be true
                end
            end

            context "when a regular user is logged in" do
                it "returns public cookbooks and the user's private cookbooks" do
                    post api_v1_graphql_path, params: { query: query }.to_json, headers: auth_headers(user)

                    json = JSON.parse(response.body)
                    data = json["data"]["publicCookbooks"]

                    expect(response).to have_http_status(:ok)

                    cookbook_ids = data.map { |cb| cb["id"].to_i }
                    expect(cookbook_ids).to include(user_private_cookbook.id)
                    expect(cookbook_ids).to include(public_cookbooks.first.cookbooks.first.id)
                    expect(cookbook_ids).to_not include(admin_private_cookbook.id)
                    expect(data.any? { |cb| cb["public"] == false }).to be true
                end
            end

            context "when an admin user is logged in" do
                it "returns all cookbooks including private ones" do
                    post api_v1_graphql_path, params: { query: query }.to_json, headers: auth_headers(admin)

                    json = JSON.parse(response.body)
                    data = json["data"]["publicCookbooks"]

                    expect(response).to have_http_status(:ok)

                    cookbook_ids = data.map { |cb| cb["id"].to_i }
                    expect(cookbook_ids).to include(admin_private_cookbook.id)
                    expect(cookbook_ids).to include(user_private_cookbook.id)
                    expect(cookbook_ids).to include(public_cookbooks.first.cookbooks.first.id)
                    expect(data.any? { |cb| cb["public"] == false }).to be true
                end
            end
        end

        describe "userCookbooks" do
            let!(:user_private_cookbook) { create(:cookbook, user: user, public: false) }
            let!(:user_public_cookbook) { create(:cookbook, user: user) }
            let!(:public_user) { create(:user) }

            let(:query) do
                <<~GRAPHQL
                    query {
                        userCookbooks {
                            id
                            cookbookName
                            public
                            user {
                                id
                            }
                        }
                    }
                GRAPHQL
            end

            context "when a regular user is logged in" do
                it "returns the user's owned cookbooks" do
                    post api_v1_graphql_path, params: { query: query }.to_json, headers: auth_headers(user)

                    json = JSON.parse(response.body)
                    data = json["data"]["userCookbooks"]

                    expect(response).to have_http_status(:ok)

                    cookbook_ids = data.map { |cb| cb["id"].to_i }
                    expect(cookbook_ids).to include(user_private_cookbook.id)
                    expect(cookbook_ids).to include(user_public_cookbook.id)
                    expect(cookbook_ids).not_to include(public_user.cookbooks.first.id)
                    expect(data.any? { |cb| cb["public"] == false }).to be true
                end
            end
        end

        describe "cookbookRecipes" do
            let(:cookbook) { user.cookbooks.first }
            let!(:recipes) { create_list(:recipe, 3) }

            before do
                recipes.each do |recipe|
                    create(:cookbook_recipe, cookbook: cookbook, recipe: recipe)
                end
            end

            let(:query) do
                <<~GRAPHQL
                    query ($id: ID!) {
                        cookbookRecipes (id: $id) {
                            id
                            cookbookName
                            public
                            user {
                                id
                            }
                            recipes {
                                id
                                name
                                image
                            }
                        }
                    }
                GRAPHQL
            end

            it "returns the cookbook and its recipes if authorized" do
                post api_v1_graphql_path, params: { query: query, variables: { id: cookbook.id } }.to_json, headers: auth_headers(user)

                json = JSON.parse(response.body)
                data = json["data"]["cookbookRecipes"]

                expect(data["id"]).to eq(cookbook.id.to_s)
                expect(data["cookbookName"]).to eq(cookbook.cookbook_name)
                expect(data["recipes"].size).to eq(3)
                expect(data["recipes"].map { |r| r["name"] }).to match_array(recipes.map(&:name))
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
