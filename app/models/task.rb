class Task < ApplicationRecord

  has_many :competitions_tasks
  has_many :competitions, through: :competitions_tasks


  belongs_to :user, optional: true
  belongs_to :kid

  accepts_nested_attributes_for :competitions_tasks

  validates :title, presence: true, length: { maximum: 100 }
  validates :content, length: { maximum: 200 }
end
