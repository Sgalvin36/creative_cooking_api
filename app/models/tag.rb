class Tag < ApplicationRecord
    has_many :cookbook_tags
    has_many :recipe_tags

    validates :tag_name, presence: true
end