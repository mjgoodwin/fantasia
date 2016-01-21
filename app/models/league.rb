class League < ActiveRecord::Base
  belongs_to :commissioner, class_name: User
end
