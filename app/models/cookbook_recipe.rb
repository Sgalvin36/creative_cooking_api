class CookbookRecipe < ApplicationRecord
    belongs_to :cookbook
    has_many :recipes
    
    validates :tried_it, presence: true
end