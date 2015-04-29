class DashboardsController < BaseController
  skip_after_action :verify_authorized

  def show
    @dashboard = dashboard
  end

  def refresh_dashboard
    @dashboard = dashboard

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
    policy_scope(DefenceRequest)
  end
end
