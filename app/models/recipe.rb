class Recipe < ApplicationRecord
    has_many :cookbook_recipes
    has_many :cookbooks, through: :cookbook_recipes
    has_many :recipe_tags
    has_many :tags, through: :recipe_tags
    has_many :recipe_ingredients
    has_many :ingredients, through: :recipe_ingredients

    validates :name, presence: true
    validates :image, presence: true
    validates :serving_size, presence: true
    
end