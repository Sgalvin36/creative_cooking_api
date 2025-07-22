FactoryBot.define do
    factory :cookbook do
        cookbook_name { Faker::Books::CultureSeries.book }
        public { true }
        association :user
    end
end
