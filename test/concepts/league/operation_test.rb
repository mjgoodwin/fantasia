require "test_helper"

class LeagueOperationTest < MiniTest::Spec
  let(:user)        { User.create(email: "mike@example.com") }

  describe "League::Create" do
    it "persists valid" do
      league = League::Create.call(league: { name: "Mickey Mouse League", commissioner: user }).model

      league.persisted?.must_equal true
      league.name.must_equal "Mickey Mouse League"
      league.commissioner.must_equal user
    end

    it "invalid - no name" do
      res, op = League::Create.run(league: { commissioner: user })

      res.must_equal false
      op.errors.to_s.must_equal  "{:name=>[\"can't be blank\"]}"
    end

    it "invalid - no commissioner" do
      res, op = League::Create.run(league: { name: "Mickey Mouse League" })

      res.must_equal false
      op.errors.to_s.must_equal  "{:commissioner=>[\"can't be blank\"]}"
    end
  end
end
