require 'rails_helper'

RSpec.describe UserRecipeModification, type: :model do
    describe "associations" do
        it { should belong_to(:user)}
        it { should belong_to(:recipe)}
        it { should have_many(:ingredient_modifications)}
    end 
end
