class Round < ActiveRecord::Base
  class Create < Trailblazer::Operation
    include Model
    model Round, :create

    contract do
      property :league
      property :start_time
      property :name
      property :number

      validates :league, presence: true
      validates :start_time, presence: true
      # validates :start_time ...
    end

    def process(params)
      validate(params[:round]) do |f|
        f.save
      end
    end
  end
end
