module LeagueSetupHelper
  def create_league!(name: "Mickey Mouse League", commissioner: nil, start_time: nil, sport: nil)
    commissioner ||= User::Create.(user: {email: "mike@example.com"}).model
    start_time ||= Time.now.end_of_day
    sport ||= Sport.find_by_name("Golf")
    League::Create.(league:
      { name: "Mickey Mouse League",
        commissioner: commissioner,
        rounds: [{ start_time: start_time }],
        sport: { id: sport.id } }
    ).model
  end
end
