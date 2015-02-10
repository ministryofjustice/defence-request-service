class BaseController < ApplicationController
  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  after_action :verify_authorized, except: :index

  private
  def user_not_authorized
    render text: t('not_authorized'), status: 403
  end
end
