require 'rails_helper'

RSpec.describe Recipe, type: :model do
    describe "associations" do
        it { should have_many(:cookbook_recipes)}
        it { should have_many(:cookbooks).through(:cookbook_recipes)}
        it { should have_many(:recipe_tags)}
        it { should have_many(:tags).through(:recipe_tags)}
        it { should have_many(:recipe_ingredients)}
        it { should have_many(:ingredients).through(:recipe_ingredients)}
    end

    describe "validations" do
        it { should validate_presence_of(:name) }
        it { should validate_presence_of(:image) }
        it { should validate_presence_of(:serving_size) }
    end  
end
