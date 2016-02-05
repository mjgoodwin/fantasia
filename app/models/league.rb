class League < ActiveRecord::Base
  belongs_to :commissioner, class_name: User
  has_many :teams

  scope :popular, lambda { order("id DESC") }

  def team_for(owner)
    teams.includes(:ownerships)
      .where("ownerships.user_id = ?", owner.id)
      .references(:ownerships)
      .first
  end
end
