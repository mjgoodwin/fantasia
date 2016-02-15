class TeamsController < ApplicationController
  def edit
    form Team::Update
    render :new
  end

  def update
    run Team::Update do |op|
      return redirect_to op.model.league
    end

    render :new
  end
end
