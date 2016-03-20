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
                 populate_if_empty: :populate_round! do

        property :start_time, writeable: :start_time_writeable?
      end

      property :sport, populator: :populate_sport!

      def populate_sport!(fragment:, **)
        self.sport = Sport.find(fragment[:id])
      end

      validates :name, presence: true
      validates :commissioner, presence: true
      validates :sport, presence: true
      validate :start_time_valid?

      def start_time_writeable?
        model.rounds.first.nil? || model.rounds.first.start_time > Time.zone.now
      end

      private

      def prepopulate_rounds!(options)
        rounds.each { |round| round.start_time = round.start_time.strftime("%Y/%m/%d %H:%M") }
        (1 - rounds.size).times { rounds << Round.new }
      end

      def populate_round!(fragment:, **)
        Round.new(start_time: fragment[:start_time])
      end

      def start_time_valid?
        return unless start_time_writeable?
        if rounds.first.nil? || rounds.first.start_time.blank?
          errors.add(:start_time, "can't be blank")
        elsif rounds.first.start_time.to_time < Time.zone.now
          errors.add(:start_time, "can't be in the past")
        end
      end
    end

    def process(params)
      params[:league][:commissioner] ||= params[:current_user]

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
      validate(params[:league]) do |f|
        f.save
      end
    end
  end
end
