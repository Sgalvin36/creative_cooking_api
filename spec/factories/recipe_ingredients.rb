FactoryBot.define do
    factory :recipe_ingredient do
        quantity { rand(1..5) }
        association :measurement
        association :ingredient
        association :recipe
    end
end
