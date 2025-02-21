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
        it { should validate_uniqueness_of(:user_name) }
        it { should validate_presence_of(:password) }
        it { should allow_value('ABCabc123321!').for(:password) }
        it { should_not allow_value('ABC').for(:password) }
        it { should_not allow_value('1234567891011').for(:password) }
        it { should_not allow_value('abcdefGHIJKL').for(:password) }
        it { should_not allow_value('123ABCabc123').for(:password) }
        it { should have_secure_password }
    end
end
