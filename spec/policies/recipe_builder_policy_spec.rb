require 'rails_helper'

describe RecipeBuilderPolicy do
    subject { described_class }

    let(:user_role) { Role.create!(name: 'user') }

    let(:regular_user) { User.create!(first_name: 'Regular', last_name: 'User', user_name: 'regular_user', password: 'Password01234!') }
    let(:guest) { nil }

    before do
        regular_user.roles << user_role
    end

    permissions :create? do
        it "grants access if user is present" do
            expect(subject).to permit(regular_user, RecipeBuilder)
        end

        it "denies access if user is nil" do
            expect(subject).not_to permit(guest, RecipeBuilder)
        end
    end
end
