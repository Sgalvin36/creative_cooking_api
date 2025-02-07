class UserRecipeModificationPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    user.present?
  end

  def update?
    user&.admin? || record.user == user
  end

  def destroy?
    user&.admin? || record.user == user
  end

end