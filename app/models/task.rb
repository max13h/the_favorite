class Task < ApplicationRecord
  has_many :competitions, through: :competitions_tasks

  belongs_to :user, optional: true
  belongs_to :kid
end
