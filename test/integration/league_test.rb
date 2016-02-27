require 'test_helper'

class LeagueIntegrationTest < Trailblazer::Test::Integration
  it "commissioner flow" do
    sign_in!("mike@example.com")
    click_link "Create League"

    # invalid.
    click_button "Create League"
    page.must_have_css ".alert"

    # correct submit.
    fill_in 'Name', with: "Mickey Mouse League"
    click_button "Create League"

    # show
    page.current_path.must_equal league_path(League.last)
    page.body.must_match /Mickey Mouse League/
    page.body.must_match /mike@example.com\s+\(Commissioner\)/

    # league listing
    visit "/"
    page.body.must_match /Mickey Mouse League/
    click_link "Mickey Mouse League"

    # edit league
    click_link "Edit"
    fill_in 'Name', with: "Donald Duck League"
    click_button "Update League"
    page.body.must_match /Donald Duck League/
  end

  it "non-commissioner flow" do
    commissioner = User::Create.(user: {email: "mike@example.com"}).model
    League::Create.(league: { name: "Mickey Mouse League", commissioner: commissioner }).model

    sign_in!("dave@example.com")
    click_link "Mickey Mouse League"
    page.wont_have_css "a", text: "Edit"
    page.wont_have_css "a", text: "Delete"
    page.wont_have_css ".roster"

    click_link "Join"
    page.wont_have_css ".roster"

    click_link "Set-up your team!"

    click_button "Save Team"
    page.must_have_css ".alert"

    fill_in "Name", with: "Mighty Ducks"
    select "Jordan Spieth", from: "Player 1"
    select "Jason Day", from: "Player 2"
    select "Bubba Watson", from: "Player 3"
    click_button "Save Team"

    page.must_have_css ".roster"
    page.body.must_match /Mighty Ducks/
    page.body.must_match /Jason Day/

    click_link "Edit"
    fill_in "Name", with: "Mighty Ducks 2"
    select "Dustin Johnson", from: "Player 2"
    click_button "Save Team"

    page.body.must_match /Mighty Ducks 2/
    page.body.wont_match /Jason Day/
    page.body.must_match /Dustin Johnson/
  end
end
