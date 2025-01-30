class RecipeBuilderPolicy < ApplicationPolicy
    def create?
        user.present?
    end

    def update?
        user.admin?
    end

end