class Team < ActiveRecord::Base
  class Create < Trailblazer::Operation
    include Model
    model Team, :create

    contract do
      property :name


      collection :owners
      validates :owners, length: {maximum: 3}
    end

    def process(params)
      validate(params[:team]) do |f|
        f.save
      end
    end
  end
end
