class Competition < ApplicationRecord
  has_many :scores
  has_many :events
  has_many :competitions_tasks
  has_many :tasks, through: :competitions_tasks

  belongs_to :couple
  belongs_to :user, optional: true
end
