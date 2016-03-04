class League < ActiveRecord::Base
  class Create < Trailblazer::Operation
    include Model
    model League, :create

    include Trailblazer::Operation::Policy
    policy League::Policy, :create?

    contract do
      property :name
      property :commissioner
      collection :rounds,
                 prepopulator: :prepopulate_rounds!,
                 populate_if_empty: :populate_rounds! do

        property :start_time
      end

      validates :name, presence: true
      validates :commissioner, presence: true

      private

      def prepopulate_rounds!(options)
        (1 - rounds.size).times { rounds << Round.new }
      end

      def populate_rounds!(fragment:, **)
        Round.new
      end
    end

    def process(params)
      params[:league][:commissioner] ||= params[:current_user]

      if params[:league][:rounds_attributes].present?
        params[:league][:rounds_attributes].each do |_, round_attributes|
          round_attributes[:start_time] = DateTime.new(
            round_attributes["start_time(1i)"].to_i,
            round_attributes["start_time(2i)"].to_i,
            round_attributes["start_time(3i)"].to_i,
            round_attributes["start_time(4i)"].to_i,
            round_attributes["start_time(5i)"].to_i
          )
        end
      end

      validate(params[:league]) do |f|
        f.save
        League::Join.(id: f.model.id, owner: f.model.commissioner)
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

    private

    def evaluate_policy(params)
      params[:current_user] ||= params[:owner]
      super(params)
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

    def process(params)
      if params[:league][:rounds_attributes].present?
        params[:league][:rounds_attributes].each do |_, round_attributes|
          round_attributes[:start_time] = DateTime.new(
            round_attributes["start_time(1i)"].to_i,
            round_attributes["start_time(2i)"].to_i,
            round_attributes["start_time(3i)"].to_i,
            round_attributes["start_time(4i)"].to_i,
            round_attributes["start_time(5i)"].to_i
          )
        end
      end

      validate(params[:league]) do |f|
        f.save
      end
    end
  end
end
