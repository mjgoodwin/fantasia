class User < ActiveRecord::Base
  has_many :ownerships
  has_many :teams, through: :ownerships
  has_many :leagues, -> { order(id: :desc) }, through: :teams

  has_many :commissionerships, class_name: League, foreign_key: "commissioner_id"

  def team_for(league)
    teams.where(league: league).first
  end

  serialize :auth_meta_data
end
