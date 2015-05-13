class DashboardsController < BaseController
  skip_after_action :verify_authorized
  before_action :set_policy_with_context, except: [:refresh_dashboard]
  before_action :set_dashboard
  before_action :set_defence_requests, only: [:show, :closed]

  def show
    @defence_requests = @active_defence_requests
  end

  def closed
    @defence_requests = @closed_defence_requests
  end

  def refresh_dashboard
    respond_to { |format| format.js }
  end

  private

  def dashboard
    Dashboard.new(
      current_user,
      defence_requests_scoped_by_policy
    )
  end

  def set_defence_requests
    @active_defence_requests = @dashboard.defence_requests.active
    @closed_defence_requests = @dashboard.defence_requests.finished
    @active_count = @active_defence_requests.count
    @closed_count = @closed_defence_requests.count
  end

  def set_dashboard
    @dashboard ||= dashboard
  end

  def set_policy_with_context
    @policy ||= policy(policy_context)
  end

  def defence_requests_scoped_by_policy
    policy_scope(policy_context)
  end

  def policy_context
    @_policy_context ||= PolicyContext.new(DefenceRequest, current_user)
  end
end
