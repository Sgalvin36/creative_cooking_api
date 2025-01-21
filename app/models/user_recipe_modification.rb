class UserRecipeModification < ApplicationRecord
    belongs_to :user
    belongs_to :recipe
    has_many :ingredient_modifications
end
