FactoryBot.define do
    factory :user do
        first_name { Faker::Name.first_name }
        last_name { Faker::Name.last_name }
        user_name { Faker::Internet.username }
        password { "Passwords123!" }
        password_confirmation { "Passwords123!" }
    
        after(:create) do |user|
            user.add_role(:user) if user.roles.blank?
        end
    end
end