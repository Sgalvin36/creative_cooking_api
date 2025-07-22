require 'rails_helper'

describe "Sessions Controller", type: :request do
    let!(:user) { create(:user) }
    let!(:cookbook1) { create(:cookbook, user: user) }
    let!(:cookbook2) { create(:cookbook, user: user) }

    it "logs in a user with valid email and password" do
        post "/api/v1/login", params: { email: user.email, password: "Passwords123!" }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include("token", "user")
    end

    it "logs in a user with valid username and password" do
        post "/api/v1/login", params: { username: user.user_name, password: "Passwords123!" }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to include("token", "user")
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
        expect(json).to include("token", "user", "roles")

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
