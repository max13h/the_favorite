class ScorePolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

  def increase_score?
    record.user == user
  end

  def decrease_score?
    record.user == user
  end
end
