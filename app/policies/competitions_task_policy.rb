class CompetitionsTaskPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

  def assign_task?
    record.task.kid.family == user.family
  end

  def mark_as_done?
    record.user == user
  end

  def unmark_as_done?
    record.user == user
  end

  def create_competitions_task?
    record.task.kid.family == user.family
  end
end
