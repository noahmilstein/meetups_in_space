require 'spec_helper'
require 'pry'

feature "as a user" do
  let(:test_user) do
    FactoryGirl.create(:user, username: "Some Guy")
  end
  let!(:populate_meetups) do
    @meetup3 = FactoryGirl.create(:meetup, name: "Charlie", user: test_user)
    @meetup1 = FactoryGirl.create(:meetup, name: "Alpha", user: test_user)
    @meetup2 = FactoryGirl.create(:meetup, name: "Bravo", user: test_user)
  end

  scenario "I want to view the details of a meetup" do
    populate_meetups
    visit "/meetups"
    sign_in_as test_user
    click_on "Alpha"

    expect(page).to have_content("Alpha")
    expect(page).to_not have_content("Meetup successfully created")
    expect(page).to have_content(@meetup1.name)
    expect(page).to have_content(@meetup1.description)
    expect(page).to have_content(@meetup1.location)
    expect(page).to have_content(@meetup1.user.username)
    expect(page).to_not have_content("Bravo")
  end

  scenario "a user can return to the meetup list from a detail page" do
    populate_meetups
    visit "/meetups"
    sign_in_as test_user
    click_on "Alpha"

    expect(page).to have_content("All Meetups")
    click_on "All Meetups"

    meetupclass = page.all(:css, ".meetup")
    expect(meetupclass.length).to eql(3)
    expect(page).to have_content("Bravo")
  end

end
