require 'rails_helper'

RSpec.describe Cookbook, type: :model do
    describe "associations" do
        it { should belong_to(:user) }
        it { should have_many(:cookbook_recipes) }
        it { should have_many(:recipes).through(:cookbook_recipes) }
        it { should have_many(:cookbook_tags) }
        it { should have_many(:tags).through(:cookbook_tags) }
    end

    describe "validations" do
        it { should validate_presence_of(:cookbook_name) }
    end

    describe "callbacks" do
        let(:user) { create(:user) }

        context "when user has only one cookbook" do
            it "does not allow destroying the last cookbook" do
                count = user.cookbooks.count
                cookbook = user.cookbooks.first
                p count
                result = cookbook.destroy

                expect(result).to be_falsey
                expect(cookbook.errors[:base]).to include("Cannot delete last cookbook.")
            end
        end

        context "when user has multiple cookbooks" do
            let!(:cookbook1) { create(:cookbook, user: user) }
            let!(:cookbook2) { create(:cookbook, user: user) }

            it "allows destroying a cookbook" do
                expect {
                    expect(cookbook1.destroy).to be_truthy
                }.to change(Cookbook, :count).by(-1)
            end
        end
    end
end
