require "test_helper"

class TeamOperationTest < MiniTest::Spec
  include LeagueSetupHelper

  let(:owner) { User::Create.(user: {email: "dave@example.com"}).model }
  let(:commissioner) { User::Create.(user: {email: "mike@example.com"}).model }
  let(:league) { create_league!(commissioner: commissioner) }

  describe "Team::Create" do
    it "persists valid" do
      team = Team::Create.(team: { league: league, owners: [owner] }).model
      team.persisted?.must_equal true
      team.league.must_equal league
      team.owners.must_equal [owner]
    end

    it "invalid - no league" do
      res, op = Team::Create.run(team: { owners: [owner] })

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
      res, op = Team::Create.run(team: { league: league, owners: [owner, owner] })

      res.must_equal false
      op.errors.to_s.must_equal "{:owners=>[\"Owners must be unique.\"]}"
    end
  end

  describe "Team::Update" do
    let(:team) { league.team_for(commissioner) }

    it "persists valid" do
      model = Team::Update.(current_user: commissioner, id: team.id, team: {
        name: "Mighty Ducks",
        memberships: [{"player_id"=>"1"}, {"player_id"=>"2"}, {"player_id"=>"3"}]}).model

      model.name.must_equal "Mighty Ducks"
      model.players.size.must_equal 3
    end

    it "invalid - no name" do
      res, op = Team::Update.run(current_user: commissioner, id: team.id, team: {
        memberships: [{"player_id"=>"1"}, {"player_id"=>"2"}, {"player_id"=>"3"}]})

      res.must_equal false
      op.errors.to_s.must_equal "{:name=>[\"Name can't be blank\"]}"
    end

    it "invalid - wrong number of players" do
      res, op = Team::Update.run(current_user: commissioner, id: team.id, team: {
        name: "Mighty Ducks",
        memberships: [{"player_id"=>"1"}, {"player_id"=>"2"}]})

      res.must_equal false
      op.errors.to_s.must_equal "{:memberships=>[\"is the wrong length (should be 3 characters)\"]}"
    end

    it "invalid - duplicate player" do
      res, op = Team::Update.run(current_user: commissioner, id: team.id, team: {
        name: "Mighty Ducks",
        memberships: [{"player_id"=>"1"}, {"player_id"=>"2"}, {"player_id"=>"2"}]})

      res.must_equal false
      op.errors.to_s.must_equal "{:memberships=>[\"Players must be unique\"]}"
    end
  end
end
