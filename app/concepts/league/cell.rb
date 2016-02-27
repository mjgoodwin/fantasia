class League::Cell < ::Cell::Concept
  property :name
  property :teams
  property :commissioner
  property :start_at

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
  end

  class Teams < League::Cell
    def show
      render :teams
    end

    private

    def user_team
      model.team_for(params[:current_user])
    end

    def rosters_locked?
      true
    end

    def policy(team)
      Team::Policy.new(params[:current_user], team)
    end
  end
end