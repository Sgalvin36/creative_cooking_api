class Cookbook < ApplicationRecord
    belongs_to :user
    has_many :cookbook_recipes
    has_many :recipes, through: :cookbook_recipes
    has_many :cookbook_tags
    has_many :tags, through: :cookbook_tags

    validates :cookbook_name, presence: true

    before_destroy :ensure_user_has_other_cookbooks

    private

    def ensure_user_has_other_cookbooks
        if user.cookbooks.limit(2).count <= 1
            errors.add(:base, "Cannot delete last cookbook.")
            throw(:abort)
        end
    end
end
