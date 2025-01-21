class Cookbook < ApplicationRecord
    belongs_to :user
    has_many :cookbook_recipes
    has_many :recipes, through: :cookbook_recipes
    has_many :cookbook_tags
    has_many :tags, through: :cookbook_tags

    validates :cookbook_name, presence: true
end
