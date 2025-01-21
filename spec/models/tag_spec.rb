require 'rails_helper'

RSpec.describe Tag, type: :model do
    describe "associations" do
        it { should have_many(:cookbook_tags)}
        it { should have_many(:recipe_tags)}
    end

    describe "validations" do
        it { should validate_presence_of(:tag_name) }
    end  
end
