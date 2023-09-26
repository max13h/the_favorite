class KidPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

  def index?
    true
  end

  def show?
    record.family == user.family
  end

  def create?
    true
  end

  def edit?
    record.family == user.family
  end

  def update?
    record.family == user.family
  end
end
