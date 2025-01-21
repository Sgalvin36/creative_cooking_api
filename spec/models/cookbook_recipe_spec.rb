require 'rails_helper'

RSpec.describe CookbookRecipe, type: :model do
    describe "associations" do
        it { should belong_to(:cookbook) }
        it { should belong_to(:recipe) }
    end

    describe "validations" do
        it { should validate_presence_of(:tried_it) }
    end
end
