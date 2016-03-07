Trailblazer::Test::Integration.class_eval do
  def sign_in!(email="mike@example.com", password="123456")
    sign_up!(email, password) #=> Session::SignUp

    visit "/sessions/sign_in_form"

    submit!(email, password)
  end

  def sign_up!(email="mike@example.com", password="123456")
    Session::SignUp.(user: {email: email, password: password, confirm_password: password})
  end

  def submit!(email, password)
    within("//form[@id='new_session']") do
      fill_in 'Email',    with: email
      fill_in 'Password', with: password
    end
    click_button "Enter"
  end
end
