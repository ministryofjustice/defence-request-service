class ApplicationController < ActionController::Base
  include Omniauth::Dsds::ControllerMethods

  protect_from_forgery with: :exception

  before_filter :authenticate_user!

  def flash_message(type, klass)
    t("models.#{type}", model: klass.model_name.human)
  end

  def current_user
    @current_user ||= ServiceUser.from_omniauth_user(super)
  end
end
