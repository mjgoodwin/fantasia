require "test_helper"

class LeagueOperationTest < MiniTest::Spec
  let(:user) { User::Create.(user: {email: "mike@example.com"}).model }
  let(:sport) { Sport.find_by_name("Golf") }

  describe "League::Create" do
    it "persists valid" do
      league = League::Create.(league: { name: "Mickey Mouse League", commissioner: user, rounds: [{ start_time: Time.zone.now.end_of_day }], sport: { id: sport.id} }).model

      league.persisted?.must_equal true
      league.name.must_equal "Mickey Mouse League"
      league.commissioner.must_equal user
    end

    it "creates commissioner's team" do
      league = League::Create.(league: { name: "Mickey Mouse League", commissioner: user, rounds: [{ start_time: Time.zone.now.end_of_day }], sport: { id: sport.id} }).model

      league.teams.size.must_equal 1
    end

    it "invalid - no name" do
      res, op = League::Create.run(league: { commissioner: user, rounds: [{ start_time: Time.zone.now.end_of_day }], sport: { id: sport.id} })

      res.must_equal false
      op.errors.to_s.must_equal "{:name=>[\"can't be blank\"]}"
    end

    it "invalid - no commissioner" do
      res, op = League::Create.run(league: { name: "Mickey Mouse League", rounds: [{ start_time: Time.zone.now.end_of_day }], sport: { id: sport.id} })

      res.must_equal false
      op.errors.to_s.must_equal "{:commissioner=>[\"can't be blank\"]}"
    end

    it "invalid - no start time" do
      res, op = League::Create.run(league: { name: "Mickey Mouse League", commissioner: user, sport: { id: sport.id} })

      res.must_equal false
      op.errors.to_s.must_equal "{:start_time=>[\"can't be blank\"]}"
    end

    it "invalid - start time in the past" do
      res, op = league = League::Create.run(league: { name: "Mickey Mouse League", commissioner: user, rounds: [{ start_time: 1.second.ago }], sport: { id: sport.id} })

      res.must_equal false
      op.errors.to_s.must_equal "{:start_time=>[\"can't be in the past\"]}"
    end

    it "invalid - no sport" do
      res, op = League::Create.run(league: { name: "Mickey Mouse League", commissioner: user, rounds: [{ start_time: Time.zone.now.end_of_day }] })

      res.must_equal false
      op.errors.to_s.must_equal "{:sport=>[\"can't be blank\"]}"
    end
  end

  describe "League::Update" do
    let(:league) { League::Create.(league: { name: "Mickey Mouse League", commissioner: user, rounds: [{ start_time: Time.zone.now.end_of_day }], sport: { id: sport.id} }).model }

    it "persists valid" do
      new_start_time = league.start_time + 1.day
      res, op = League::Update.run(current_user: league.commissioner, id: league.id, league: { rounds: [{ start_time: new_start_time }] })

      res.must_equal true
      league.reload.rounds.first.start_time.to_s.must_equal new_start_time.to_s
    end

    it "valid - change name after start time has past" do
      # time travel to after league has started
      Timecop.freeze(league.start_time + 1.day) do
        res, op = League::Update.run(current_user: league.commissioner, id: league.id, league: { name: "Donald Duck League" })

        res.must_equal true
        league.reload.name.must_equal "Donald Duck League"
      end
    end

    it "invalid - start time in the past" do
      # time travel to before league has started
      Timecop.freeze(league.start_time - 1.day) do
        new_start_time = 1.second.ago
        res, op = League::Update.run(current_user: league.commissioner, id: league.id, league: { rounds: [{ start_time: new_start_time }] })

        res.must_equal false
        op.errors.to_s.must_equal "{:start_time=>[\"can't be in the past\"]}"
      end
    end
  end
end
