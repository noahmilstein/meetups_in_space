require 'spec_helper'

feature "as a user" do
  let(:test_user) do
    FactoryGirl.create(:user, username: "Some Guy")
  end
  let!(:populate_meetups) do
    @meetup3 = FactoryGirl.create(:meetup, name: "Charlie", user: test_user)
    @meetup1 = FactoryGirl.create(:meetup, name: "Alpha", user: test_user)
    @meetup2 = FactoryGirl.create(:meetup, name: "Bravo", user: test_user)
  end

  scenario "I want to see a link on the homepage to create a new meetup" do
    populate_meetups
    visit "/meetups"
    expect(page).to have_link("Create new meetup")
  end

  scenario "I want to click a link that takes me to a form page to create a new meetup" do
    populate_meetups
    visit "/meetups"
    sign_in_as test_user
    click_link("Create new meetup")

    expect(page).to have_content("Create new meetup")
    expect(page).to have_content("Name")
    expect(page).to have_content("Description")
    expect(page).to have_content("Time")
    expect(page).to have_content("Location")
  end

  scenario "I want to create a new meetup from the 'new' page" do
    populate_meetups
    visit '/meetups'
    sign_in_as test_user
    click_link("Create new meetup")

    expect(page).to have_content("Create new meetup")

    fill_in "Name", with: "Nathan's Cool Meetup"
    fill_in "Description", with: "This is a test"
    fill_in "Time", with: "2016-09-10 16:00:00"
    fill_in "Location", with: "Boston"
    click_on "Submit"

    expect(page).to have_content("Meetups")
    expect(page).to have_content("Nathan's Cool Meetup")
    expect(page).to have_link("Meetups")
    expect(page).to have_content("Meetup successfully created")
  end

  scenario "I must be signed in in order to create a new meetup" do
    populate_meetups
    visit '/meetups'
    click_link("Create new meetup")

    expect(page).to have_content("You must sign in first.")
  end

  scenario "I must supply all requisite field information" do
    populate_meetups
    visit '/meetups'
    sign_in_as test_user
    click_link("Create new meetup")
    fill_in "Name", with: "Nathan's Cool Meetup"
    click_on "Submit"

    expect(page).to have_content("Description can't be blank")
    expect(page).to have_content("Time can't be blank")
    expect(page).to have_content("Location can't be blank")
  end

  scenario "I must supply all requisite field information" do
    populate_meetups
    visit '/meetups'
    sign_in_as test_user
    click_link("Create new meetup")
    fill_in "Description", with: "This is a test"
    click_on "Submit"

    expect(page).to have_content("Time can't be blank")
    expect(page).to have_content("Name can't be blank")
    expect(page).to have_content("Location can't be blank")
  end
  scenario "I must supply all requisite field information" do
    populate_meetups
    visit '/meetups'
    sign_in_as test_user
    click_link("Create new meetup")
    fill_in "Time", with: "2016-09-10 16:00:00"
    click_on "Submit"

    expect(page).to have_content("Description can't be blank")
    expect(page).to have_content("Name can't be blank")
    expect(page).to have_content("Location can't be blank")
  end

  scenario "I must supply all requisite field information" do
    populate_meetups
    visit '/meetups'
    sign_in_as test_user
    click_link("Create new meetup")
    fill_in "Location", with: "Boston"
    click_on "Submit"

    expect(page).to have_content("Description can't be blank")
    expect(page).to have_content("Name can't be blank")
    expect(page).to have_content("Time can't be blank")
  end

end
