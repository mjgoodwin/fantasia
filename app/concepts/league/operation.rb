class League < ActiveRecord::Base
  class Create < Trailblazer::Operation
    include Model
    model League, :create

    contract do
      property :name
      property :commissioner

      validates :name, presence: true
      validates :commissioner, presence: true
    end

    def process(params)
      params[:league][:commissioner] ||= params[:current_user]

      validate(params[:league]) do |f|
        f.save
      end
    end
  end

  class Show < Trailblazer::Operation
    include Model
    model League, :find

    # include Trailblazer::Operation::Policy
    # policy League::Policy, :show?
  end
end
