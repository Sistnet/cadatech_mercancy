class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[new create]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> {
    redirect_to new_session_path, alert: t("sessions.errors.rate_limited")
  }

  layout "auth"

  def new
  end

  def create
    if (admin = Admin.active.unlocked.authenticate_by(email: params[:email], password: params[:password]))
      admin.record_login!
      start_new_session_for admin
      redirect_to after_authentication_url
    else
      Admin.active.find_by(email: params[:email])&.increment_login_attempts!
      redirect_to new_session_path, alert: t("sessions.errors.invalid")
    end
  end

  def destroy
    terminate_session
    redirect_to new_session_path, status: :see_other
  end
end
