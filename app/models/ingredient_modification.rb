class IngredientModification < ApplicationRecord
    belongs_to :ingredient
    belongs_to :recipe_ingredient
    belongs_to :measurement
    belongs_to :user_recipe_modification

    validates :modified_quantity, presence: true
end
