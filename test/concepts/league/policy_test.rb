require "test_helper"

class LeaguePolicyTest < MiniTest::Spec
  include LeagueSetupHelper

  let (:commissioner) { User::Create.(user: { email: "mike@example.com" }).model }
  let (:league) { create_league!(commissioner: commissioner) }

  let (:policy) { League::Update.policy_config.(user, league) }

  describe "League::Policy" do
    describe "#update?" do
      describe "NOT signed in" do
        let (:user) { nil }
        it { policy.update?.must_equal false }
      end

      describe "signed in" do
        let (:user) { User::Create.(user: {email: "dave@example.com"}).model }

        # is commissioner
        it do
          policy = League::Update.policy_config.(commissioner, league)
          policy.update?.must_equal true
        end

        # not commissioner
        it do
          policy = League::Update.policy_config.(user, league)
          policy.update?.must_equal false
        end
      end

      describe "admin" do
        let (:admin) { User::Create.(user: {"email"=> "noochworldorder@gmail.com"}).model }

        # is commissioner
        it do
          league = create_league!(name: "Donald Duck League", commissioner: admin)
          policy = League::Update.policy_config.(admin, league)

          policy.update?.must_equal true
        end

        # not commissioner
        it do
          policy = League::Update.policy_config.(admin, league)
          policy.update?.must_equal true
        end
      end

      describe "#join?" do
        let (:user) { User::Create.(user: {email: "dave@example.com"}).model }

        it "non-members can join" do
          policy.join?.must_equal true
        end

        it "members can't join" do
          Team::Create.(team: { league: league, owners: [user] })
          policy.join?.must_equal false
        end
      end
    end
  end
end
