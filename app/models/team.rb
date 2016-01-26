class Team < ActiveRecord::Base
  has_many :ownerships
  has_many :owners, through: :ownerships, source: :user
  has_many :players
  belongs_to :league
end
