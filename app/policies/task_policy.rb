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

  def mark_as_recurent?
    record.kid.family == user.family
  end

  def unmark_as_recurent?
    record.kid.family == user.family
  end

  def update?
    record.kid.family == user.family
  end
end
