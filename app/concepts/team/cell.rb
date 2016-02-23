
class Team::Cell < ::Cell::Concept
  property :name
  property :owners
  property :players

  def show
    render
  end

  private

  def policy
    @policy ||= Team::Policy.new(params[:current_user], model)
  end

  def initialized?
    name.present?
  end
end
