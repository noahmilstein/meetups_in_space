require 'spec_helper'

feature "as a user" do
  let(:test_user) do
    FactoryGirl.create(:user, username: "Some Guy")
  end
  let(:anon_user) do
    FactoryGirl.create(:user, username: "Some Other Guy")
  end

  let!(:populate_meetups) do
    @meetup3 = FactoryGirl.create(:meetup, name: "Charlie", user: test_user)
    @meetup1 = FactoryGirl.create(:meetup, name: "Alpha", user: test_user)
    @meetup2 = FactoryGirl.create(:meetup, name: "Bravo", user: test_user)
  end

  scenario "On a meetup's show page, there should be a button to join the meetup if I am not signed in or if I am signed in, but I am not a member of the meetup." do
    populate_meetups
    visit "/meetups"
    click_link(@meetup1.name)

    expect(page).to have_link("Meetup")
  end

  scenario "On a meetup's show page, there should be a button to join the meetup if I am not signed in or if I am signed in, but I am not a member of the meetup." do
    populate_meetups
    visit "/meetups"
    sign_in_as anon_user
    click_link(@meetup1.name)

    expect(page).to have_button("Join Meetup")
  end

  scenario "On a meetup's show page, there should be a button to join the meetup if I am not signed in or if I am signed in, but I am not a member of the meetup." do
    populate_meetups
    visit "/meetups"
    sign_in_as test_user
    click_link(@meetup1.name)
    click_button("Join Meetup")
    click_link("All Meetups")
    click_link(@meetup1.name)

    expect(page).to_not have_button("Join Meetup")
  end

  scenario "If I am signed in and I click the button, I should see a message that says that I have joined the meetup and I should be added to the meetup's members list" do
    populate_meetups
    visit "/meetups"
    sign_in_as anon_user
    click_link(@meetup1.name)
    click_button("Join Meetup")

    expect(page).to have_content("Signup successful")
    expect(page).to have_content(anon_user.username)
  end

  scenario "If I am not signed in and I click the button, I should see a message which says that I must sign in" do
    populate_meetups
    visit "/meetups"
    click_link(@meetup1.name)
    click_button("Join Meetup")

    expect(page).to have_content("You must be signed in")
  end

end
