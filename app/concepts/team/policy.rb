class Team::Policy
  include Fantasia::Policy

  def create?
    true
  end

  def show?
    true
  end

  def update?
    edit?
  end

  def edit?
    signed_in? && (admin? || user.teams.include?(model))
  end

  def delete?
    edit?
  end
end
