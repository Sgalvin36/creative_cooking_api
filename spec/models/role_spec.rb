require 'rails_helper'

RSpec.describe Role, type: :model do
  it { should have_and_belong_to_many(:users).join_table(:users_roles) }
end

describe 'validations' do
  it 'validates resource_type inclusion in Rolify.resource_types' do
    valid_resource_type = Rolify.resource_types.sample
    invalid_resource_type = 'InvalidType'

    role = Role.new(name: "user", resource_type: valid_resource_type)
    expect(role).to be_valid

    role.resource_type = invalid_resource_type
    expect(role).not_to be_valid
  end
end

# Scope tests
describe 'scopes' do
  it 'responds to scopify-defined methods' do
    # Test for any custom scopes defined by the `scopify` method
    expect(Role).to respond_to(:global) # Replace `with_role` with any specific scopify-generated scope.
  end
end

# Behavior tests
describe 'behavior' do
  it 'allows creating a role without a resource' do
    role = Role.new(name: 'admin')
    expect(role).to be_valid
  end

  it 'allows creating a role with a resource' do
    user = create(:user)
    resource = create(:cookbook, user: user)
    role = Role.new(name: 'editor', resource: resource)
    expect(role).to be_valid
  end

  it 'is invalid without a name' do
    role = Role.new
    expect(role).not_to be_valid
    expect(role.errors[:name]).to include("can't be blank")
  end
end

describe 'Role Seeds', type: :model do
  before(:all) do
    Rails.application.load_seed # Load the seeds file
  end

  it 'creates the admin role' do
    expect(Role.find_by(name: 'admin')).to be_present
  end

  it 'creates the editor role' do
    expect(Role.find_by(name: 'editor')).to be_present
  end

  it 'creates the viewer role' do
    expect(Role.find_by(name: 'user')).to be_present
  end

  after(:all) do
    Role.destroy_all
    Cookbook.destroy_all
    User.destroy_all
  end
end
