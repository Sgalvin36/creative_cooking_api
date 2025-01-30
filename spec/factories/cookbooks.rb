FactoryBot.define do
    factory :cookbook do
        cookbook_name { Faker::Books::CultureSeries.book }
        association :user
    end
end