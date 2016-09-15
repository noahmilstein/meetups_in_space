class Meetup < ActiveRecord::Base
  has_many :signups
  has_many :users, through: :signups
  belongs_to :user
end
