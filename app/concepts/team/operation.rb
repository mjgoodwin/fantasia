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
  end

  class Update < Trailblazer::Operation
    include Model
    model Team, :update

    include Trailblazer::Operation::Policy
    policy Team::Policy, :update?

    contract do
      property :name
      collection :players,
        prepopulator: :prepopulate_players!,
        populate_if_empty: :populate_players! do

        property :id
        validates :id, presence: true
      end

      validates :name, presence: true
      validates :players, length: { is: 3 }

      private

      def prepopulate_players!(options)
        (3 - players.size).times { players << Player.new }
      end

      def populate_players!(fragment:, **)
        Player.find_by_id(fragment["id"]) || Player.new
      end
    end

    def process(params)
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
