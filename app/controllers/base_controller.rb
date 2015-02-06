class BaseController < ApplicationController
  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action ->(c) { authorize controller_name.classify.constantize, "#{c.action_name}?" }
  after_action :verify_authorized

  private
  def user_not_authorized
    render text: t('not_authorized'), status: 403
  end
end
