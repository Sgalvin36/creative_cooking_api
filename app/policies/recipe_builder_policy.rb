class RecipeBuilderPolicy < ApplicationPolicy
    def create?
        user.present?
    end

end