class Competition < ApplicationRecord
  has_many :scores
  has_many :events
  has_many :competitions_tasks
  has_many :tasks, through: :competitions_tasks

  belongs_to :family
  belongs_to :user, optional: true

  validates :family, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :reward, presence: true, length: { maximum: 100 }
end
