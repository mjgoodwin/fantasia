class League < ActiveRecord::Base
  belongs_to :commissioner, class_name: User

  scope :popular, lambda { order("id DESC") }
end
