class BaseController < ApplicationController
  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  before_action { |controller| authorize controller }
  after_action :verify_authorized

  private
  def user_not_authorized
    render text: t('not_authorized'), status: 403
  end
end