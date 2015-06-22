class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:create, :failure]

  def create
    session[:user_token] = auth_hash.fetch(:credentials).fetch(:token)

    redirect_to redirect_url
  end

  private

  def redirect_url
    custody_suite_root_url if user_role == "cso"
  end

  # TODO: This is hacky
  def user_role
    @user_role ||= current_user.organisations.map { |o| o["roles"] }.flatten.uniq.first
  end

  def auth_hash
    request.env["omniauth.auth"]
  end
end
