module Session
  class Setup < Trailblazer::Operation
    def process(params)
      params[:current_user] = params[:tyrant].current_user
    end
  end

  class Impersonate < Trailblazer::Operation
    include Policy
    policy Team::Policy, :admin?

    def setup!(params)
      Setup.(params)
      return unless params[:as]
      super # runs policy.
      impersonate!(params)
    end

    def process(params)
    end

    private

    def impersonate!(params)
      simulated = User.find_by!(email: params[:as])
      params[:current_user] = simulated
      params[:real_user]    = params[:tyrant].current_user
    end
  end
end
