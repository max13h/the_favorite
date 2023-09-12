class Kid < ApplicationRecord
  has_many :events
  has_many :tasks

  belongs_to :couple
end
