class SessionsController < ApplicationController
  # before_filter should be used when op not involved at all.
  before_filter( only: [:sign_in_form, :sign_up_form]) { redirect_to root_path if tyrant.signed_in? }

  def sign_up_form
    form Session::SignUp
  end

  def sign_up
    run Session::SignUp do |op|
      tyrant.sign_in!(op.model)
      return redirect_to root_path
    end

    render action: :sign_up_form
  end

  def sign_in_form
    form Session::SignIn
  end

  def sign_in
    run Session::SignIn do |op|
      tyrant.sign_in!(op.model)
      return redirect_to root_path
    end

    render action: :sign_in_form
  end

  def sign_out
    run Session::SignOut do
      tyrant.sign_out!
      redirect_to root_path
    end
  end
end
