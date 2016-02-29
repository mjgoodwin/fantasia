class League < ActiveRecord::Base
  belongs_to :commissioner, class_name: User
  has_many :teams
  has_many :rounds

  scope :popular, lambda { order("id DESC") }

  def team_for(owner)
    teams.joins(:owners).where("users.id = ?", owner.id).first
  end
end
