module LeagueSetupHelper
  def create_league!(name: "Mickey Mouse League", commissioner: nil, start_time: nil)
    commissioner ||= User::Create.(user: {email: "mike@example.com"}).model
    League::Create.(league:
      { name: "Mickey Mouse League",
        commissioner: commissioner,
        rounds: [{ start_time: start_time || Time.now.end_of_day }] }
    ).model
  end
end
