class League < ActiveRecord::Base
  class Create < Trailblazer::Operation
    include Model
    model League, :create

    contract do
      property :name

      validates :name, presence: true
    end

    def process(params)
      validate(params[:league]) do |f|
        f.save
      end
    end
  end
end
