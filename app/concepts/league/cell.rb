class League::Cell < ::Cell::Concept
  property :name
  property :teams
  property :commissioner

  class Summary < League::Cell
    def show
      render :summary
    end

    private

    def policy
      operation.policy
    end

    def operation
      options.fetch :update_operation
    end

    def start_time
      model.start_time.strftime("%B %d, %-l:%M %p")
    end
  end

  class Teams < League::Cell
    def show
      render :teams
    end

    private

    def user_team
      model.team_for(params[:current_user])
    end

    def policy(team)
      Team::Policy.new(params[:current_user], team)
    end

    def round
      rounds.first
    end
  end
end
