class RecipePolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def update?
    user&.admin?
  end

  def destroy?
    user&.admin?
  end
end