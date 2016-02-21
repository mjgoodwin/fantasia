require "test_helper"

class TeamOperationTest < MiniTest::Spec
  let(:commissioner) { User::Create.(user: {email: "mike@example.com"}).model }
  let(:league) { League::Create.(league: { name: "Mickey Mouse League", commissioner: commissioner }).model }

  describe "Team::Create" do
    it "persists valid" do
      team = Team::Create.(team: { league: league, owners: [commissioner] }).model
      team.persisted?.must_equal true
      team.league.must_equal league
      team.owners.must_equal [commissioner]
    end

    it "invalid - no league" do
      res, op = Team::Create.run(team: { owners: [commissioner] })

      res.must_equal false
      op.errors.to_s.must_equal "{:league=>[\"can't be blank\"]}"
    end

    it "invalid - no owners" do
      res, op = Team::Create.run(team: { league: league })

      res.must_equal false
      op.errors.to_s.must_equal "{:owners=>[\"is too short (minimum is 1 character)\"]}"
    end

    it "invalid - too many owners" do
      owners = 3.times.collect { |i| User::Create.(user: {email: "#{i}@example.com"}).model }
      res, op = Team::Create.run(team: { league: league, owners: owners })

      res.must_equal false
      op.errors.to_s.must_equal "{:owners=>[\"is too long (maximum is 2 characters)\"]}"
    end

    it "invalid - duplicate owner" do
      res, op = Team::Create.run(team: { league: league, owners: [commissioner, commissioner] })

      res.must_equal false
      op.errors.to_s.must_equal "{:owners=>[\"Owners must be uniqe.\"]}"
    end
  end
end
