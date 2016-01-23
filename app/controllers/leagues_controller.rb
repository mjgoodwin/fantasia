class LeaguesController < ApplicationController
  def new
    form League::Create
  end

  def create
    run League::Create do |op|
      return redirect_to op.model
    end

    render :new
  end

  def show
    present League::Show
  end
end
