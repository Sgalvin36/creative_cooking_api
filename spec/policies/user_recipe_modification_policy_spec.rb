require 'rails_helper'

RSpec.describe UserRecipeModificationPolicy, type: :policy do
  let(:admin_role) { Role.create!(name: 'admin') }
  let(:user_role) { Role.create!(name: 'user') }

  let(:admin) { User.create!(first_name: 'Admin', last_name: 'User', user_name: 'admin_user', password: 'Password01234!') }
  let(:regular_user) { User.create!(first_name: 'Regular', last_name: 'User', user_name: 'regular_user', password: 'Password01234!') }
  let(:other_user) {create(:user)}
  let(:guest) { nil }

  let(:recipe) {create(:recipe)}
  let(:record) { UserRecipeModification.create!(user_id: regular_user.id, recipe_id: recipe.id)}

  before do
    admin.roles << admin_role 
    regular_user.roles << user_role 
    other_user.roles << user_role
  end

  permissions :index?, :show? do
    it "grants access to anyone" do
      expect(described_class).to permit(guest, record)
      expect(described_class).to permit(other_user, record)
      expect(described_class).to permit(admin, record)
    end
  end

  permissions :create? do
    it "grants access if user is present" do
      expect(described_class).to permit(regular_user, record)
      expect(described_class).to permit(admin, record)
    end

    it "denies access if user is nil" do
      expect(described_class).not_to permit(guest, record)
    end
  end

  permissions :update?, :destroy? do
    it "grants access if user is an admin" do
      expect(described_class).to permit(admin, record)
    end

    it "grants access if user owns the record" do
      expect(described_class).to permit(regular_user, record)
    end

    it "denies access if user is not an admin and does not own the record" do
      expect(described_class).not_to permit(other_user, record)
      expect(described_class).not_to permit(guest, record)
    end
  end
end
