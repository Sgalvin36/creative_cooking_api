require 'rails_helper'

RSpec.describe CookbookTag, type: :model do
    describe "associations" do
        it { should belong_to(:cookbook) }
        it { should belong_to(:tag) }
    end
end
