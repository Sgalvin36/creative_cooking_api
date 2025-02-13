class UserPolicy < ApplicationPolicy
  def index?
    user.admin? 
  end

  def show?
    user.admin? || record == user
  end

  def update?
    user.admin? || record == user
  end

  def destroy?
    user.admin?
  end

  def execute?
    user
  end
  
  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.admin?
        scope.all 
      else
        scope.where(id: user.id)
      end
    end
  end
end
