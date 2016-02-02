require "test_helper"

class LeagueOperationTest < MiniTest::Spec
  let(:user) { User::Create.(user: {email: "mike@example.com"}).model }

  describe "League::Create" do
    it "persists valid" do
      league = League::Create.(league: { name: "Mickey Mouse League", commissioner: user }).model

      league.persisted?.must_equal true
      league.name.must_equal "Mickey Mouse League"
      league.commissioner.must_equal user
    end

    it "creates commissioner's team" do
      league = League::Create.(league: { name: "Mickey Mouse League", commissioner: user }).model

      league.teams.size.must_equal 1
    end

    it "invalid - no name" do
      res, op = League::Create.run(league: { commissioner: user })

      res.must_equal false
      op.errors.to_s.must_equal "{:name=>[\"can't be blank\"]}"
    end

    it "invalid - no commissioner" do
      res, op = League::Create.run(league: { name: "Mickey Mouse League" })

      res.must_equal false
      op.errors.to_s.must_equal "{:commissioner=>[\"can't be blank\"]}"
    end
  end
end
