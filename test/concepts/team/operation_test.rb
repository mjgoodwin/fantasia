require "test_helper"

class TeamOperationTest < MiniTest::Spec
  let(:user) { User::Create.(user: {email: "mike@example.com"}).model }

  describe "League::Create" do
    # it "persists valid" do
    #   league = League::Create.(league: { name: "Mickey Mouse League", commissioner: user }).model

    #   league.persisted?.must_equal true
    #   league.name.must_equal "Mickey Mouse League"
    #   league.commissioner.must_equal user
    # end
  end
end
