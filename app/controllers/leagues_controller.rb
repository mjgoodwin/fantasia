class LeaguesController < ApplicationController
  def new
    form League::Create
  end
end
