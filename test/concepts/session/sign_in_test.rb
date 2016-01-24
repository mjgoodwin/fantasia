require "test_helper"

class SessionSignInTest < MiniTest::Spec
  it "valid credentials" do
    sign_in_op = Session::SignUp.(user: {
      email: "mike@example.com", password: "123123", confirm_password: "123123",
    })

    res, op = Session::SignIn.run(session: {
      email: "mike@example.com",
      password: "123123"
    })

    op.model.must_equal sign_in_op.model
  end

  it "wrong password" do
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

  it "empty form" do
    res, op = Session::SignIn.run(session: {
      email: "",
      password: ""
    })

    res.must_equal false
  end
end
