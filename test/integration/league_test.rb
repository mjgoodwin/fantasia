require 'test_helper'

class LeagueIntegrationTest < Trailblazer::Test::Integration
  it do
    sign_in!("mike@example.com")
    click_link "Create League"

    # invalid.
    click_button "Create League"
    page.must_have_css ".error"

    # correct submit.
    fill_in 'Name', with: "Mickey Mouse League"
    click_button "Create League"

    # show
    page.current_path.must_equal league_path(League.last)
    page.body.must_match /Mickey Mouse League/
    page.body.must_match /Commish: mike@example.com/

    # # edit
    # league = league.last
    # visit "/leagues/#{league.id}/edit"
    # page.wont_have_css "form #league_name"
    
    # league listing
    visit "/"
    page.body.must_match /Mickey Mouse League/
  end
end
