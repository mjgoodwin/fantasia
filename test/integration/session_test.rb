require 'test_helper'

class SessionIntegrationTest < Trailblazer::Test::Integration
  def submit_sign_up!(email, password, confirm)
    within("//form[@id='new_user']") do
      fill_in 'Email',    with: email
      fill_in 'Password', with: password
      fill_in 'Password, again', with: confirm
    end
    click_button "Sign up!"
  end

  it do
    visit "sessions/sign_up_form"

    page.must_have_css "#user_email"
    page.must_have_css "#user_password"
    page.must_have_css "#user_confirm_password"

    # empty
    submit_sign_up!("", "", "")

    page.must_have_css "#user_email"

    # wrong everything.
    submit_sign_up!("wrong", "123", "")
    page.must_have_css "#user_email" # value?

    # password mismatch.
    submit_sign_up!("mike@example.com", "123", "321")
    page.must_have_css "#user_email" # value?

    # successful sign up and redirect
    submit_sign_up!("mike@example.com", "123", "123")
    page.current_path.must_equal "/"
    page.must_have_content "Hi, mike@example.com"
  end

  # wrong login.
  it do
    visit "/sessions/sign_in_form"
    # login form is present.
    page.must_have_css "#session_email"
    page.must_have_css "#session_password"

    # incorrect password
    submit! "mike@example.com", "wrong"

    # login form is present, again.
    page.must_have_css "#session_email"
    page.must_have_css "#session_password"

    # empty login.
    submit! "", ""

    # login form is present, again.
    page.must_have_css "#session_email"
    page.must_have_css "#session_password"
  end

  # sucessful session.
  it do
    visit "sessions/sign_up_form"
    submit_sign_up!("mike@example.com", "123", "123")

    page.must_have_content "Hi, mike@example.com" # login success.

    # no sign_in screen for logged in.
    visit "/sessions/sign_in_form"
    page.must_have_content "Welcome to Fantasia"

    # no sign_up screen for logged in.
    visit "/sessions/sign_up_form"
    page.must_have_content "Welcome to Fantasia"
  end

  # sign_out.
  it do
    visit "sessions/sign_out"
    page.current_path.must_equal "/"
    page.wont_have_content "Hi, mike@example.com" # login success.

    sign_in!
    page.must_have_content "Hi, mike@example.com" # login success.

    click_link "Sign Out"
    page.current_path.must_equal "/"
    page.wont_have_content "Hi, mike@example.com" # login success.
  end
end
