class Task < ApplicationRecord
  has_many :competitions, through: :competitions_tasks

  belongs_to :user
  belongs_to :couple
end
