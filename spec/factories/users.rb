FactoryBot.define do
    factory :user do
        first_name { Faker::Name.first_name }
        last_name { Faker::Name.last_name }
        user_name { Faker::Internet.unique.username }
        email { Faker::Internet.unique.email }
        password { "Passwords123!" }
        password_confirmation { "Passwords123!" }

        trait :admin do
            after(:create) do |user|
                user.add_role(:admin)
            end
        end
    end
end
