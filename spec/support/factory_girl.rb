require 'factory_girl'

FactoryGirl.define do
  factory :user do
    provider "github"
    sequence(:uid) { |n| n }
    sequence(:username) { |n| "jarlax#{n}" }
    sequence(:email) { |n| "jarlax#{n}@launchacademy.com" }
    avatar_url "https://avatars2.githubusercontent.com/u/174825?v=3&s=400"
  end
end

FactoryGirl.define do
  factory :meetup do
    sequence(:name) { |n| "name #{n}"}
    sequence(:description) { |n| "The biggest shindigiest hootenany this side of Kalamazoo #{n}"}
    sequence(:location) { |n| "This side of Kalamazoo #{n}" }
    user User.first
    time "2016-09-20 18:00:00"
  end
end
