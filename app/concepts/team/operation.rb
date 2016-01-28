class Team < ActiveRecord::Base
  class Create < Trailblazer::Operation
    include Model
    model Team, :create

    contract do
      property :name
      property :league
      collection :owners

      validates :league, presence: true
      validates :owners, length: { maximum: 2 }
    end

    def process(params)
      validate(params[:team]) do |f|
        f.save
      end
    end

    private

    def setup_model!(params)
      model.owners.build
    end
  end
end
