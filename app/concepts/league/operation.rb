class League < ActiveRecord::Base
  class Create < Trailblazer::Operation
    include Model
    model League, :create

    include Trailblazer::Operation::Policy
    policy League::Policy, :create?

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
        Team::Create.(team: { league: f.model, owners: [f.model.commissioner] })
      end
    end
  end

  class Join < Trailblazer::Operation
    include Model
    model League, :find

    include Trailblazer::Operation::Policy
    policy League::Policy, :join?

    def process(params)
      params[:owner] ||= params[:current_user]

      validate(params) do |f|
        Team::Create.(team: { league: f.model, owners: [params[:owner]] })
      end
    end
  end

  class Show < Trailblazer::Operation
    include Model
    model League, :find

    include Trailblazer::Operation::Policy
    policy League::Policy, :show?
  end

  class Update < Create
    policy League::Policy, :update?
    action :update
  end
end
