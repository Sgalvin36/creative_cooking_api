class CookbookPolicy < ApplicationPolicy
  def show?
    !!(record.public? || record.user == user || user&.has_role?(:admin))
  end

  def update?
    user && (record.user == user || user.has_role?(:editor, record) || user.has_role?(:admin))
  end

  def destroy?
    return false if user.nil?
    return true if user.has_role?(:admin)

    user_cookbook_count = user.cookbooks.limit(2).count
    user == record.user && user_cookbook_count > 1
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
