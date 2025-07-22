require 'rails_helper'

RSpec.describe UserPolicy, type: :policy do
  let(:admin_role) { Role.find_or_create_by(name: 'admin') }
  let(:user_role) { Role.find_or_create_by(name: 'user') }

  let(:admin_user) { User.create!(first_name: 'Admin', last_name: 'User', email: "admin@example.com", user_name: 'admin_user', password: 'Password01234!') }
  let(:regular_user) { User.create!(first_name: 'Regular', last_name: 'User', email: "regular@example.com", user_name: 'regular_user', password: 'Password01234!') }

  before do
    admin_user.add_role(:admin)
    regular_user.add_role(:user)
  end

  subject(:policy) { UserPolicy.new(user, record) }

  describe 'UserPolicy permissions' do
    context 'for admin user' do
      let(:user) { admin_user }

      describe '#index?' do
        it 'allows admin to access all users' do
          policy = UserPolicy.new(user, nil)
          expect(policy.index?).to be_truthy
        end
      end

      describe '#show?' do
        let(:record) { admin_user }

        it 'allows admin to see any user' do
          expect(policy.show?).to be_truthy
        end
      end

      describe '#update?' do
        let(:record) { regular_user }

        it 'allows admin to update any user' do
          expect(policy.update?).to be_truthy
        end
      end

      describe '#destroy?' do
        let(:record) { regular_user }

        it 'allows admin to destroy any user' do
          expect(policy.destroy?).to be_truthy
        end
      end
    end

    context 'for regular user' do
      let(:user) { regular_user }

      describe '#index?' do
        let(:record) { regular_user }

        it 'prevents regular users from accessing other users' do
          expect(policy.index?).to be_falsey
        end
      end

      describe '#show?' do
        let(:record) { regular_user }

        it 'allows regular users to see their own record' do
          expect(policy.show?).to be_truthy
        end

        context 'when trying to access another user' do
          let(:record) { admin_user }

          it 'prevents regular users from accessing other users' do
            expect(policy.show?).to be_falsey
          end
        end
      end

      describe '#update?' do
        let(:record) { regular_user }

        it 'allows regular users to update their own record' do
          expect(policy.update?).to be_truthy
        end

        context 'when trying to update another user' do
          let(:record) { admin_user }

          it 'prevents regular users from updating other users' do
            expect(policy.update?).to be_falsey
          end
        end
      end

      describe '#destroy?' do
        let(:record) { regular_user }

        it 'prevents regular users from destroying other users' do
          expect(policy.destroy?).to be_falsey
        end
      end
    end
  end

  describe 'Scope' do
    context 'for admin user' do
      let(:user) { admin_user }

      it 'allows admin to view all users' do
        scope = UserPolicy::Scope.new(user, User.all)
        expect(scope.resolve).to eq(User.all)
      end
    end

    context 'for regular user' do
      let(:user) { regular_user }

      it 'limits scope to the current user' do
        scope = UserPolicy::Scope.new(user, User.all)
        expect(scope.resolve).to eq([ regular_user ])
      end
    end
  end
end
