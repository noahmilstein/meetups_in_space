class Meetup < ActiveRecord::Base
  validates :name, presence: true
  validates :description, presence: true
  validates :location, presence: true
  validates :time, presence: true

  has_many :signups
  has_many :users, through: :signups
  belongs_to :user
end
