class TaskPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

  def show?
    user.family == record.kid.family
  end

  def create?
    true
  end

  def mark_as_done?
    true
  end
end
