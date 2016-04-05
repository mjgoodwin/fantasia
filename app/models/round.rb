class Round < ActiveRecord::Base
  belongs_to :league
  has_and_belongs_to_many :games
  has_many :memberships
  has_many :players, through: :memberships
end
