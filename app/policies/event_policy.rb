class EventPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

  def assign_event?
    record.kid.family == user.family
  end

  def show?
    record.kid.family == user.family
  end

  def create?
    # true
    false
  end

  def unassign_event?
    record.kid.family == user.family
  end

  def update?
    # record.kid.family == user.family
    false
  end
end
