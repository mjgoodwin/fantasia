class User < ActiveRecord::Base
  has_many :ownerships
  has_many :teams, through: :ownerships
  has_many :leagues, through: :teams

  has_many :commissionerships, class_name: League, foreign_key: "commissioner_id"

  serialize :auth_meta_data
end
