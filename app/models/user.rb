class User < ActiveRecord::Base
  has_many :teams
  has_many :commissionerships, class_name: League, foreign_key: "commissioner_id"

  serialize :auth_meta_data
end
