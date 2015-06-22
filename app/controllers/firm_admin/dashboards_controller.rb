class FirmAdmin::DashboardsController < BaseController
  skip_after_action :verify_authorized
  before_action :set_policy_with_context, except: [:refresh_dashboard]
  before_action :set_dashboard

  def show
    @dashboard.set_visibility! params[:id]
  end

  def refresh_dashboard
    respond_to { |format| format.js }
  end

  private

  def dashboard
    Dashboard.new(
      current_user,
      defence_requests_scoped_by_policy,
      client
    )
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
    @policy_context ||= PolicyContext.new(DefenceRequest, current_user)
  end
end
