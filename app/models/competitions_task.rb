class CompetitionsTask < ApplicationRecord
  belongs_to :task
  belongs_to :competition
  belongs_to :user, optional: true

  validates :deadline, inclusion: { in: (Date.today..Date.today + 1.years), allow_nil: true }
end
