class Measurement < ApplicationRecord
    has_many :recipe_ingredients
    has_many :ingredient_modifications

    validates :unit, presence: true
end