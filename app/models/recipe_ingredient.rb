class RecipeIngredient < ApplicationRecord
    belongs_to :recipe
    belongs_to :ingredient
    belongs_to :measurement
    has_many :ingredient_modifications

    validates :quantity, presence: true
end
