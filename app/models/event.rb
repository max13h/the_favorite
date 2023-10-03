class Event < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :competition, optional: true
  belongs_to :kid

  validates :title, presence: true, length: { maximum: 100 }
  validates :content, length: { maximum: 200 }
  validates :date, presence: true, inclusion: { in: (Date.today..Date.today + 5.years), message: "must be after today" }
end
