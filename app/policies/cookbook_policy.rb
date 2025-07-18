class CookbookPolicy < ApplicationPolicy
  def show?
    !!(record.public? || record.user == user || user&.has_role?(:admin))
  end

  def update?
    user && (record.user == user || user.has_role?(:editor, record) || user.has_role?(:admin))
  end

  def destroy?
    user&.has_role?(:admin)
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if user&.has_role?(:admin)
        scope.all
      elsif user
        scope.where("public = ? OR user_id = ?", true, user.id)
      else
        scope.where(public: true)
      end
    end
  end
end
