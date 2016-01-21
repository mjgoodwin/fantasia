require "test_helper"

class SessionImpersonateTest < Trailblazer::Test::Integration
  let (:dave) { User::Create.(user: {email: "dave@example.com"}) }
  before { dave }

  # anonymous can't.
  it do
    visit "/?as=dave@example.com"
    page.must_have_css "a", text: "Sign In" # not logged in.
  end

  # signed-in can't.
  it do
    sign_in!("mike@example.com")
    visit "/?as=dave@example.com"
    page.must_have_content "Hi, mike@example.com" # signed-in but no impersonation.
  end

  # admin can.
  it do
    sign_in!("noochworldorder@gmail.com")
    visit "/?as=dave@example.com"
    page.must_have_content "Hi, dave@example.com" # signed-in but no impersonation.
  end
end
