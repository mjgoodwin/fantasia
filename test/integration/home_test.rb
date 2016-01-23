require 'test_helper'

class HomeIntegrationTest < Trailblazer::Test::Integration
  it do
    visit "/"
    page.must_have_content "Welcome to Fantasia"
    page.wont_have_css "ul.menu li a", text: "My Team"
    page.wont_have_css "a.button", text: "Create League"

    sign_in!
    page.must_have_content "Leagues"
    page.must_have_css "ul.menu li a", text: "My Team"
    page.must_have_css "a.button", text: "Create League"
  end
end
