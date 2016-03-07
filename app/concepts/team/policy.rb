class Team::Policy
  include Fantasia::Policy

  def create?
    true
  end

  def show?
    admin_or_owner? || roster_locked?
  end

  def update?
    edit?
  end

  def edit?
    admin_or_owner? && !roster_locked?
  end

  def delete?
    edit?
  end

  private

  def admin_or_owner?
    signed_in? && (admin? || owner?)
  end

  def owner?
    user.teams.include?(model)
  end

  def roster_locked?
    model.league.rounds.first.start_time < Time.zone.now
  end
end
