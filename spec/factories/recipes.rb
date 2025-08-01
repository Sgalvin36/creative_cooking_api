FactoryBot.define do
    factory :recipe do
        name { Faker::Restaurant.name }
        # image { "https://arthurmillerfoundation.org/wp-content/uploads/2018/06/default-placeholder.png" }
        image { Faker::LoremFlickr.image(size: "300x300", search_terms: [ 'food' ]) }
        serving_size { Faker::Number.between(from: 1, to: 10) }
    end
end
