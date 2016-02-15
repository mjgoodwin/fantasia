class Team < ActiveRecord::Base
  class Create < Trailblazer::Operation
    include Model
    model Team, :create

    include Trailblazer::Operation::Policy
    policy Team::Policy, :create?

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

  class Update < Trailblazer::Operation
    include Model
    model Team, :update

    include Trailblazer::Operation::Policy
    policy Team::Policy, :update?

    contract do
      property :name

      validates :name, presence: true
    end

    def process(params)
      # binding.pry
      validate(params[:team]) do |f|
        f.save
      end
    end
  end

  class Show < Trailblazer::Operation
    include Model
    model Team, :find

    include Trailblazer::Operation::Policy
    policy Team::Policy, :show?
  end
end
