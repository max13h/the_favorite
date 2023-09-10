class CompetitionsTask < ApplicationRecord
  belongs_to :task
  belongs_to :competition
end
