require 'rails_helper'

RSpec.describe Cookbook, type: :model do
    describe "associations" do
        it { should belong_to(:user) }
        it { should have_many(:cookbook_recipes)}
        it { should have_many(:recipes).through(:cookbook_recipes)}
    end

    describe "validations" do
        it { should validate_presence_of(:cookbook_name) }
    end  
end
