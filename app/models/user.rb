class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :events
  has_many :scores
  has_many :competitions
  has_many :tasks
  has_many :competitions_tasks

  belongs_to :family, optional: true

  has_one_attached :picture

  validates :first_name, presence: true, length: { maximum: 33 }
  validates :last_name, presence: true, length: { maximum: 33 }
end
