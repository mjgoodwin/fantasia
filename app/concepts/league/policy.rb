class League::Policy
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
    signed_in? && (admin? || (user == model.commissioner))
  end

  def delete?
    edit?
  end

  def join?
    user.leagues.exclude? model
  end

  def input_scores?
    edit? && model.start_time < Time.zone.now
  end
end
