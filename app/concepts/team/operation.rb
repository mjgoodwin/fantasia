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
      validates :owners, length: { in: 1..2 }
      validate :owners_unique?

      private

      def owners_unique?
        return if owners.size == owners.uniq.size
        errors.add("owners", "Owners must be unique.")
      end
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
                 populator: :populate_player! do

        property :id
        validates :id, presence: true
      end

      validates :name, presence: true
      validates :players, length: { is: 3 }
      validate :valid_roster?

      private

      def prepopulate_players!(options)
        (3 - players.size).times { players << Player.new }
      end

      def populate_player!(collection:, index:, fragment:, **)
        player = Player.find_by_id(fragment["id"]) || Player.new
        collection.delete(collection[index])
        collection.insert(index, player)
      end

      def valid_roster?
        return if players.map(&:model).size == players.map(&:model).uniq.size
        errors.add("players", "Players must be unique.")
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
