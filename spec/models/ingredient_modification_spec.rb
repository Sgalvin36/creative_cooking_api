require 'rails_helper'

RSpec.describe IngredientModification, type: :model do
    describe "associations" do
        it { should belong_to(:ingredient)}
        it { should belong_to(:recipe_ingredient)}
        it { should belong_to(:user_recipe_modification)}
        it { should belong_to(:measurement)}
    end

    describe "validations" do
        it { should validate_presence_of(:modified_quantity) }
    end  
end
