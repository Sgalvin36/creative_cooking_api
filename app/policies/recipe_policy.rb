class RecipePolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def update?
    user&.has_role?(:admin)
  end

  def destroy?
    user&.has_role?(:admin)
  end
end
