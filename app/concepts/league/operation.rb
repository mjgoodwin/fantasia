class League < ActiveRecord::Base
  class Create < Trailblazer::Operation
    include Model
    model League, :create

    def process(params)
      @model = League.create(params[:league])
    end
  end
end