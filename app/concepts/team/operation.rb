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
      collection :memberships,
                 prepopulator: :prepopulate_memberships!,
                 populator: :populate_membership! do

        property :player_id
        validates :player_id, presence: { message: "Player is missing" }
      end

      validates :name, presence: { message: "Name can't be blank" }
      validates :memberships, length: { is: 3 }
      validate :valid_roster?

      private

      def prepopulate_memberships!(options)
        (3 - memberships.size).times { memberships << Membership.new }
      end

      def populate_membership!(collection:, index:, fragment:, **)
        membership = Membership.find_by_id(fragment["id"]) || Membership.new
        membership.round = model.league.first_round
        collection.delete(collection[index])
        collection.insert(index, membership)
      end

      def valid_roster?
        return if memberships.map(&:player_id).size == memberships.map(&:player_id).uniq.size
        errors.add("memberships", "Players must be unique")
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
