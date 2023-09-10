class Competition < ApplicationRecord
  has_many :scoreboards
  has_many :tasks, through: :competitions_tasks

  belongs_to :couple
  belongs_to :user
end
