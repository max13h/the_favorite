class CompetitionPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

  def index?
    true
  end

  def create?
    user.family == record.family
  end

  def destroy?
    true
  end

  def show?
    user.family == record.family
  end
end
