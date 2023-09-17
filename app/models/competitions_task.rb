class CompetitionsTask < ApplicationRecord
  belongs_to :task
  belongs_to :competition
  belongs_to :user, optional: true

end
