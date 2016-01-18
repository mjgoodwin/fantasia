class User < ActiveRecord::Base
  has_many :teams

  serialize :auth_meta_data
end
