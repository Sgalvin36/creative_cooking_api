require 'rails_helper'

RSpec.describe CookbookPolicy, type: :policy do
  let(:admin_role) { Role.find_or_create_by(name: 'admin') }
  let(:user_role) { Role.find_or_create_by(name: 'user') }

  let(:admin_user) { User.create!(first_name: 'Admin', last_name: 'User', email: "admin@example.com", user_name: 'admin_user', password: 'Password01234!') }
  let(:regular_user) { User.create!(first_name: 'Regular', last_name: 'User', email: "regular@example.com", user_name: 'regular_user', password: 'Password01234!') }
  let(:other_user) { User.create!(first_name: 'Other', last_name: 'User', email: "other@example.com", user_name: 'other_user', password: 'Password01234!') }

  before do
    admin_user.add_role(:admin)
    regular_user.add_role(:user)
    other_user.add_role(:user)
  end

  let(:cookbook) { Cookbook.create!(cookbook_name: "Testy Test", user: regular_user, public: false) }
  let(:public_cookbook) { Cookbook.create!(cookbook_name: "Public Taste", user: other_user, public: true) }
  let(:other_cookbook) { Cookbook.create!(cookbook_name: "Other Private Cookbook", user: other_user, public: false) }

  subject { described_class }

  describe '.scope' do
    before(:each) do
      cookbook.reload
      public_cookbook.reload
      other_cookbook.reload
    end

    it "allows admin to see all cookbooks" do
      policy_scope = CookbookPolicy::Scope.new(admin_user, Cookbook.all).resolve
      expect(policy_scope.to_a).to include(cookbook, public_cookbook, other_cookbook)
    end

    it "allows user to see their own cookbooks and all public cookbooks" do
      policy_scope = CookbookPolicy::Scope.new(regular_user, Cookbook.all).resolve

      expect(policy_scope.to_a).to include(cookbook, public_cookbook)
      expect(policy_scope.to_a).not_to include(other_cookbook)
    end

    it "allows guests to see only public cookbooks" do
      policy_scope = CookbookPolicy::Scope.new(nil, Cookbook.all).resolve

      expect(policy_scope.to_a).to include(public_cookbook)
    end
  end

  describe '#show?' do
    it "allows admin to view any cookbook" do
      expect(subject.new(admin_user, cookbook).show?).to be true
    end

    it "allows user to view their own cookbook and public cookbooks" do
      expect(subject.new(regular_user, cookbook).show?).to be true
      expect(subject.new(regular_user, public_cookbook).show?).to be true
    end

    it "allows guests to view public cookbooks" do
      expect(subject.new(nil, public_cookbook).show?).to be true
    end

    it "prevents user from viewing someone else's private cookbook" do
      expect(subject.new(regular_user, other_cookbook).show?).to be false
    end

    it "prevents guest from viewing someone else's private cookbook" do
      expect(subject.new(nil, other_cookbook).show?).to be false
    end
  end

  describe '#update?' do
    it "allows admin to update any cookbook" do
      expect(subject.new(admin_user, cookbook).update?).to be true
    end

    it "allows user to update their own cookbook" do
      expect(subject.new(regular_user, cookbook).update?).to be true
    end

    it "prevents user from updating someone's public cookbook" do
      expect(subject.new(regular_user, public_cookbook).update?).to be false
    end

    it "prevents user from updating someone else's private cookbook" do
      expect(subject.new(regular_user, other_cookbook).update?).to be false
    end
  end

  describe '#destroy?' do
    it "allows admin to destroy any cookbook" do
      expect(subject.new(admin_user, cookbook).destroy?).to be true
    end

    it "prevents user from destroying someone else's cookbook" do
      expect(subject.new(regular_user, other_cookbook).destroy?).to be false
    end

    it "prevents user from destroying their own cookbook" do
      expect(subject.new(regular_user, cookbook).destroy?).to be false
    end
  end
end
