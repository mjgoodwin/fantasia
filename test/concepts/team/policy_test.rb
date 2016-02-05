require "test_helper"

class TeamPolicyTest < MiniTest::Spec
  let (:commissioner) { User::Create.(user: { email: "mike@example.com" }).model }
  let (:owner) { User::Create.(user: { email: "dave@example.com" }).model }
  let (:league) { League::Create.(league: { name: "Mickey Mouse League", commissioner: commissioner }).model }
  let (:team) { Team::Create.(team: { league: league, owners: [owner] }).model }

  let (:policy) { Team::Update.policy_config.(user, team) }

  describe "Team::Policy" do
    describe "NOT signed in" do
      let (:user) { nil }
      it { policy.update?.must_equal false }
    end

    describe "signed in" do
      let (:user) { User::Create.(user: {email: "brian@example.com"}).model }

      # is owner
      it do
        policy = Team::Update.policy_config.(owner, team)
        policy.update?.must_equal true
      end

      # is commissioner
      it do
        policy = Team::Update.policy_config.(commissioner, team)
        policy.update?.must_equal false
      end

      # random user
      it do
        policy = Team::Update.policy_config.(user, team)
        policy.update?.must_equal false
      end
    end

    describe "admin" do
      let (:admin) { User::Create.(user: {"email"=> "noochworldorder@gmail.com"}).model }

      # is owner
      it do
        team = Team::Create.(team: { league: league, owners: [admin] }).model
        policy = Team::Update.policy_config.(admin, team)

        policy.update?.must_equal true
      end

      # not owner
      it do
        policy = Team::Update.policy_config.(admin, team)
        policy.update?.must_equal true
      end
    end
  end
end
