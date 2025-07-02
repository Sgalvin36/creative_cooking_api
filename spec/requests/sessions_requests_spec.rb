require 'rails_helper'

describe "Sessions Controller", type: :request do
    let!(:user) { create(:user) }

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
end
