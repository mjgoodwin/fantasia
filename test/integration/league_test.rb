require 'test_helper'

class LeagueIntegrationTest < Trailblazer::Test::Integration
  it do
    sign_in!
    click_link "Create League"
  end
end
