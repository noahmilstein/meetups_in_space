require 'spec_helper'
require 'pry'

feature "as a user" do
  let(:test_user) do
    FactoryGirl.create(:user, username: "Some Guy")
  end
  let!(:populate_meetups) do
    meetup3 = FactoryGirl.create(:meetup, name: "Charlie", user: test_user)
    meetup1 = FactoryGirl.create(:meetup, name: "Alpha", user: test_user)
    meetup2 = FactoryGirl.create(:meetup, name: "Bravo", user: test_user)
  end

  scenario "I want to view list of all available meetups" do
    populate_meetups
    visit "/meetups"
    # save_and_open_page
    sign_in_as test_user

    expect(page).to have_content("Alpha")
    expect(page).to have_content("Bravo")
    expect(page).to have_content("Charlie")

    meetupclass = page.all(:css, ".meetup")
    expect(meetupclass.length).to eql(3)
  end

  scenario "meetups should be listed alphabetically" do
    populate_meetups
    visit "/meetups"
    sign_in_as test_user

    meetupclass = page.all(:css, ".meetup")
    expect(meetupclass[0].text).to have_content("Alpha")
    expect(meetupclass[1].text).to have_content("Bravo")
    expect(meetupclass[2].text).to have_content("Charlie")
  end

end
