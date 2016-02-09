class Team::Cell < ::Cell::Concept
  property :owners
  property :players

  def show
    render
  end
end
