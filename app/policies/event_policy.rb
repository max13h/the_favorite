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
    record.user.family == user.family
  end
end
