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

  def edit
    form League::Update
    render :new
  end

  def update
    run League::Update do |op|
      return redirect_to op.model
    end

    render :new
  end
end
