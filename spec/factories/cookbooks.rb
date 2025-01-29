FactoryBot.define do
    factory :cookbook do
        cookbook_name { "My Awesome Cookbook" }
        association :user
    end
end