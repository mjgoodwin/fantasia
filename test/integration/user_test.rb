require 'test_helper'

class UserIntegrationTest < Trailblazer::Test::Integration
  # visit new profile page
  it do
    sign_in!("mike@example.com")

    click_link "Hi, mike@example.com"
    page.must_have_content "Member Since:"
  end
end
