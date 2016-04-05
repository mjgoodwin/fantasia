class Game < ActiveRecord::Base
  belongs_to :sport
  has_and_belongs_to_many :rounds
end
