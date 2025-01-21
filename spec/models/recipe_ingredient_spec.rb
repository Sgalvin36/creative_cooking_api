require 'rails_helper'

RSpec.describe RecipeIngredient, type: :model do
    describe "associations" do
        it { should belong_to(:ingredient) }
        it { should belong_to(:recipe) }
        it { should belong_to(:measurement) }
        it { should have_many(:ingredient_modifications) }
    end

    describe "validations" do
        it { should validate_presence_of(:quantity) }
    end
end
