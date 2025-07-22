FactoryBot.define do
    factory :measurement do
        unit { %w[cup tbsp tsp oz lb g kg ml l pinch dash slice].sample }
    end
end
