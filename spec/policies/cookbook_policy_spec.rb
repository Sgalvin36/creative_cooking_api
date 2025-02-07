require 'rails_helper'

RSpec.describe CookbookPolicy, type: :policy do
  let(:admin_role) { Role.create!(name: 'admin') }
  let(:user_role) { Role.create!(name: 'user') }

  let(:admin_user) { User.create!(first_name: 'Admin', last_name: 'User', user_name: 'admin_user', password: 'Password01234!') }
  let(:regular_user) { User.create!(first_name: 'Regular', last_name: 'User', user_name: 'regular_user', password: 'Password01234!') }

  before do
    admin_user.roles << admin_role 
    regular_user.roles << user_role 
  end

  let(:cookbook) { Cookbook.create!(cookbook_name: "Testy Test", user: regular_user) }
  let(:other_user_cookbook) { create(:cookbook, user: (create(:user))) }

  subject { described_class }

  describe '.scope' do
    it "allows admin to see all cookbooks" do
      policy_scope = CookbookPolicy::Scope.new(admin_user, Cookbook.all).resolve
      expect(policy_scope.to_a).to eq(Cookbook.all.to_a) 
    end
    
    it "allows user to see only their own cookbooks" do
      policy_scope = CookbookPolicy::Scope.new(regular_user, Cookbook.all).resolve
      regular_user.reload
      cookbook.reload

      expect(policy_scope.to_a).to eq([cookbook]) 
    end
  end

  describe '#show?' do
    it "allows admin to view any cookbook" do
      expect(subject.new(admin_user, cookbook).show?).to be true
    end

    it "allows user to view their own cookbook" do
      expect(subject.new(regular_user, cookbook).show?).to be true
    end

    it "prevents user from viewing someone else's cookbook" do
      expect(subject.new(regular_user, other_user_cookbook).show?).to be false
    end
  end

  describe '#update?' do
    it "allows admin to update any cookbook" do
      expect(subject.new(admin_user, cookbook).update?).to be true
    end

    it "allows user to update their own cookbook" do
      expect(subject.new(regular_user, cookbook).update?).to be true
    end

    it "prevents user from updating someone else's cookbook" do
      expect(subject.new(regular_user, other_user_cookbook).update?).to be false
    end
  end

  describe '#destroy?' do
    it "allows admin to destroy any cookbook" do
      expect(subject.new(admin_user, cookbook).destroy?).to be true
    end

    it "prevents user from destroying someone else's cookbook" do
      expect(subject.new(regular_user, other_user_cookbook).destroy?).to be false
    end

    it "prevents user from destroying their own cookbook" do
      expect(subject.new(regular_user, cookbook).destroy?).to be false
    end
  end
end
