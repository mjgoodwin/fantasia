require "test_helper"

class SessionSignInTest < MiniTest::Spec
  # successful.
  it do
    sign_in_op = Session::SignUp.(user: {
      email: "mike@example.com", password: "123123", confirm_password: "123123",
    })

    res, op = Session::SignIn.run(session: {
      email: "mike@example.com",
      password: "123123"
    })

    op.model.must_equal sign_in_op.model
  end

  # wrong password.
  it do
    sign_in_op = Session::SignUp.(user: {
      email: "mike@example.com", password: "123123", confirm_password: "123123",
    })

    res, op = Session::SignIn.run(session: {
      email: "mike@example.com",
      password: "wrong"
    })

    res.must_equal false
    op.model.must_equal nil
  end

  # empty form.
  it do
    res, op = Session::SignIn.run(session: {
      email: "",
      password: ""
    })

    res.must_equal false
  end
end
