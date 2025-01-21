class Ingredient < ApplicationRecord
    has_many :recipe_ingredients
    has_many :ingredient_modifications
    has_many :recipes, through: :recipe_ingredients

    validates :name, presence: true
end
