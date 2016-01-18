class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def tyrant
    Tyrant::Session.new(request.env['warden'])
  end
  helper_method :tyrant

  require_dependency "session/impersonate"
  before_filter { Session::Impersonate.(params.merge!(tyrant: tyrant)) }

  rescue_from Trailblazer::NotAuthorizedError, with: :user_not_authorized

  def user_not_authorized
    flash[:message] = "Not authorized, my friend."
    redirect_to root_path
  end
end
