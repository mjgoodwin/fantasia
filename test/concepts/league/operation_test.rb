require "test_helper"

class LeagueOperationTest < MiniTest::Spec
  let(:user)        { User.create(email: "mike@example.com") }
  # let (:user)        { User::Create.(user: {email: "mike@example.com"}).model }
  describe "Create" do
    it "persists valid" do
      league = League::Create.call(league: { name: "Mickey Mouse League", commissioner: user }).model

      league.persisted?.must_equal true
      league.name.must_equal "Mickey Mouse League"
      # league.commissioner.must_equal user
    end
  end
end
