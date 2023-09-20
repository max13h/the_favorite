class Family < ApplicationRecord
  has_many :events
  has_many :users
  has_many :tasks
  has_many :kids
  has_many :competitions
end
