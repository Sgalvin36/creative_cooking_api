class CookbookRecipe < ApplicationRecord
    belongs_to :cookbook
    belongs_to :recipe

    validates :tried_it, presence: true
end
