class DashboardsController < BaseController
  skip_after_action :verify_authorized

  def show
    @policy = policy(PolicyContext.new(DefenceRequest, current_user))
    @dashboard = dashboard
  end

  def refresh_dashboard
    @defence_requests = defence_requests_scoped_by_policy

    respond_to { |format| format.js }
  end

  private

  def dashboard
    Dashboard.new(
      current_user,
      defence_requests_scoped_by_policy
    )
  end

  def defence_requests_scoped_by_policy
    policy_scope(PolicyContext.new(DefenceRequest, current_user))
  end
end
