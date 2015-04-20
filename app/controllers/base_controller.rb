class BaseController < ApplicationController
  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  after_action :verify_authorized, except: :index

  private
  def user_not_authorized
    render file: 'public/403.html', :status => :not_found, :layout => false
  end
end
