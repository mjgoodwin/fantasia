class League < ActiveRecord::Base
  belongs_to :commissioner, class_name: User
  has_many :teams

  scope :popular, lambda { order("id DESC") }
end
