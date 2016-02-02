class Team::Policy
  include Fantasia::Policy

  def create?
    true
  end

  # the problem here is that we need deciders to differentiate between contexts (e.g. signed_in?)
  # that we actually already know, e.g. Create::SignedIn knows it is signed in.
  #
  # Idea: Team::Policy::Update.()
  def update?
    edit?
  end

  def show?
    true
  end

  def edit?
    signed_in? && (admin? || user.teams.include?(model))
  end

  def delete?
    edit?
  end
end
