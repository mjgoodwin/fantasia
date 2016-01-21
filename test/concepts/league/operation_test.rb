require "test_helper"

class LeagueOperationTest < MiniTest::Spec
  let (:user)        { User.create(email: "mike@example.com") }
  # let (:user)        { User::Create.(user: {email: "mike@example.com"}).model }
  describe "Create" do
    it "persists valid" do
      res, op = League::Create.(league: {name: "Mickey Mouse League", commissioner: user})
    end
  end
end
