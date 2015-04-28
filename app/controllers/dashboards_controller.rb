class DashboardsController < BaseController
  skip_after_action :verify_authorized
  before_filter :set_dashboard_count, only: [:show, :closed]

  def show
    @dashboard = dashboard
  end

  def closed
    @dashboard = dashboard
  end

  def refresh_dashboard
    @defence_requests = defence_requests_scoped_by_policy

    respond_to { |format| format.js }
  end

  private

  def set_dashboard_count
    @active_count ||= dashboard.defence_requests(:active).count
    @closed_count ||= dashboard.defence_requests(:closed).count
  end

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
