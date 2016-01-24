require "test_helper"

class SessionSignUpTest < MiniTest::Spec
  it "valid input" do
    res, op = Session::SignUp.run(user: {
      email: "mike@example.com",
      password: "123123",
      confirm_password: "123123",
    })

    op.model.persisted?.must_equal true
    op.model.email.must_equal "mike@example.com"

    assert Tyrant::Authenticatable.new(op.model).digest == "123123"
  end

  it "empty input" do
    res, op = Session::SignUp.run(user: {
      email: "",
      password: "",
      confirm_password: "",
    })

    res.must_equal false
    op.model.persisted?.must_equal false
    op.errors.to_s.must_equal "{:email=>[\"can't be blank\", \"is invalid\"], :password=>[\"can't be blank\"], :confirm_password=>[\"can't be blank\"]}"
  end

  it "password mismatch" do
    res, op = Session::SignUp.run(user: {
      email: "mike@example.com",
      password: "123123",
      confirm_password: "wrong",
    })

    res.must_equal false
    op.model.persisted?.must_equal false
    op.errors.to_s.must_equal "{:password=>[\"Passwords don't match\"]}"
  end

  it "email taken" do
    Session::SignUp.run(user: {
      email: "mike@example.com", password: "123123", confirm_password: "123123",
    })

    res, op = Session::SignUp.run(user: {
      email: "mike@example.com",
      password: "abcabc",
      confirm_password: "abcabc",
    })

    res.must_equal false
    op.model.persisted?.must_equal false
    op.errors.to_s.must_equal "{:email=>[\"has already been taken\"]}"
  end
end
