class Kid < ApplicationRecord
  has_many :events
  has_many :tasks

  belongs_to :family

  has_one_attached :picture

  validates :name, presence: true, length: { maximum: 50 }
  validates :blood_type, inclusion: { in: ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"] }
  validates :doctor_number, length: { maximum: 50 }
end
