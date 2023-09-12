class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :notifications
  has_many :events
  has_many :scoreboards
  has_many :competitions
  has_many :tasks

  has_one :couple
end
