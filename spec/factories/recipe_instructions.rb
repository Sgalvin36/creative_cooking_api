FactoryBot.define do
    factory :recipe_instruction do
        association :recipe
        instruction { "This step happens here" }
        instruction_step { 1 }
    end
end
