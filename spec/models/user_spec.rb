require 'rails_helper'

RSpec.describe User, type: :model do
    describe "associations" do
        it { should have_many(:cookbooks) }
        it { should have_many(:user_recipe_modifications)}
    end
  
    describe "validations" do
        it { should validate_presence_of(:first_name) }
        it { should validate_presence_of(:last_name) }
        it { should validate_uniqueness_of(:user_name) }
        it { should validate_presence_of(:role)}
        it { should validate_presence_of(:password) }
        it { should have_secure_password }
    end  
end
