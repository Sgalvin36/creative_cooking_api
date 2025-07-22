require 'rails_helper'

RSpec.describe User, type: :model do
    describe "associations" do
        it { should have_many(:cookbooks) }
        it { should have_many(:user_recipe_modifications) }
        it { should have_and_belong_to_many(:roles).join_table(:users_roles) }
    end

    describe "validations" do
        it { should validate_presence_of(:first_name) }
        it { should validate_presence_of(:last_name) }
        it { should validate_presence_of(:password) }
        it { should allow_value('ABCabc123321!').for(:password) }
        it { should_not allow_value('ABC').for(:password) }
        it { should_not allow_value('1234567891011').for(:password) }
        it { should_not allow_value('abcdefGHIJKL').for(:password) }
        it { should_not allow_value('123ABCabc123').for(:password) }
        it { should have_secure_password }

        it "does not allow duplicate user_name" do
            User.create!(
                first_name: "Test",
                last_name: "User",
                email: "testuser@example.com",
                password: "BestPassword123!!"
            )

            duplicate = User.new(
                first_name: "test",
                last_name: "user",
                email: "user2@example.com",
                password: "SuperStrong123!!"
            )

            expect(duplicate).not_to be_valid
            expect(duplicate.errors[:user_name]).to include("has already been taken")
        end
    end

    describe "callbacks / custom methds" do
        let(:regular_user) do
            User.create!(first_name: 'Regular', last_name: 'User', email: "regular@example.com", user_name: 'regular_user', password: 'Password01234!')
        end

        describe "#assign_default_role" do
            it "assigns the 'user' role by default" do
                expect(regular_user.roles.map(&:name)).to include ("user")
            end
        end

        describe "#create_default_cookbook" do
            it "creates a default cookbook for the user" do
                cookbook = regular_user.cookbooks.first
                expect(cookbook).to be_a(Cookbook)
                expect(cookbook.cookbook_name).to eq("Regular's Cookbook")
            end
        end

        describe "#set_role" do
            it "adds a new role if not in the list of roles" do
                expect(regular_user.roles.count).to eq(2)
                regular_user.set_role("admin")
                expect(regular_user.roles.count).to eq(3)
            end

            it "does not add duplicate roles to the list of roles" do
                expect(regular_user.roles.count).to eq(2)
                regular_user.set_role("user")
                expect(regular_user.roles.count).to eq(2)
            end
        end

        describe "#set_user_name" do
            it "sets username with first name and last name" do
                user = User.new(
                    first_name: "Test",
                    last_name: "User",
                    email: "testuser@example.com",
                    password: "BestPassword123!!"
                )

                user.set_user_name

                expect(user.user_name).to eq("Test User")
            end

            it "sets randomized username when no first name or last name is present" do
                user = User.new()

                user.set_user_name

                expect(user.user_name).to match(/\AUser [0-9a-f]{6}\z/)
            end
        end

        describe "#set_slug" do
            it "sets slug using parameterized first and last name" do
                user = User.new(first_name: "Bill", last_name: "Ted")
                user.set_slug
                expect(user.slug).to eq("bill-ted")
            end

            it "sets slug using username if names are missing" do
                user = User.new(user_name: "Bill_n_Ted_360")
                user.set_slug
                expect(user.slug).to eq("bill_n_ted_360")
            end

            it "sets slug to a random hex if no values are present" do
                allow(SecureRandom).to receive(:hex).with(9).and_return("abc123xyz")
                user = User.new
                user.set_slug
                expect(user.slug).to eq("abc123xyz")
            end

            it "prevents duplicate slugs being assigned to multiple users" do
                existing = User.create!(first_name: "Bob", last_name: "Tomato", email: "bob@example.com", password: "SuperPass123!")
                expect(existing.slug).to eq("bob-tomato")

                allow(SecureRandom).to receive(:hex).with(3).and_return("def123")
                user = User.new(first_name: "Bob", last_name: "Tomato")
                user.set_slug

                expect(user.slug).to eq("bob-tomato-def123")
            end
        end
    end
end
