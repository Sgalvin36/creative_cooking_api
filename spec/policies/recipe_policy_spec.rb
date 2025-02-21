require 'rails_helper'

describe RecipePolicy do
  subject { described_class }

  let(:admin_role) { Role.create!(name: 'admin') }
  let(:user_role) { Role.create!(name: 'user') }

  let(:admin_user) { User.create!(first_name: 'Admin', last_name: 'User', user_name: 'admin_user', password: 'Password01234!') }
  let(:regular_user) { User.create!(first_name: 'Regular', last_name: 'User', user_name: 'regular_user', password: 'Password01234!') }
  let(:guest) { nil }

  before do
    admin_user.roles << admin_role
    regular_user.roles << user_role
  end

  permissions :index? do
    it "grants access to anyone" do
      expect(subject).to permit(guest, Recipe)
      expect(subject).to permit(regular_user, Recipe)
      expect(subject).to permit(admin_user, Recipe)
    end
  end

  permissions :show? do
    it "grants access to anyone" do
      expect(subject).to permit(guest, Recipe)
      expect(subject).to permit(regular_user, Recipe)
      expect(subject).to permit(admin_user, Recipe)
    end
  end

  permissions :update? do
    it "grants access if user is an admin" do
      expect(subject).to permit(admin_user, Recipe)
    end

    it "denies access if user is not an admin" do
      expect(subject).not_to permit(regular_user, Recipe)
      expect(subject).not_to permit(guest, Recipe)
    end
  end

  permissions :destroy? do
    it "grants access if user is an admin" do
      expect(subject).to permit(admin_user, Recipe)
    end

    it "denies access if user is not an admin" do
      expect(subject).not_to permit(regular_user, Recipe)
      expect(subject).not_to permit(guest, Recipe)
    end
  end
end
