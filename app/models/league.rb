class League < ActiveRecord::Base
  belongs_to :commissioner, class_name: User
  belongs_to :sport
  has_many :teams
  has_many :rounds

  scope :popular, lambda { order("id DESC") }

  delegate :start_time, to: :first_round

  def team_for(owner)
    teams.joins(:owners).where("users.id = ?", owner.id).first
  end

  def first_round
    rounds.first
  end
end
