class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:create, :failure]

  def create
    session[:user_token] = auth_hash.fetch(:credentials).fetch(:token)

    redirect_to redirect_url
  end

  private

  def redirect_url
    custody_suite_root_url if current_user.role == "cso"
  end

  def auth_hash
    request.env["omniauth.auth"]
  end
end
