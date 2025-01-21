require 'rails_helper'

RSpec.describe RecipeInstruction, type: :model do
    describe "associations" do
        it { should belong_to(:recipe)}
    end 

    describe "validations" do
        it { should validate_presence_of(:instruction_step) }
        it { should validate_presence_of(:instruction) }
    end
end
