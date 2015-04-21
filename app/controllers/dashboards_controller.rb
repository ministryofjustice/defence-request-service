class DashboardsController < BaseController
  skip_after_action :verify_authorized

  def show
    @dashboard = dashboard
  end

  def refresh_dashboard
    respond_to do |format|
      format.js { @dashboard = dashboard }
    end
  end

  private

  def dashboard
    Dashboard.for(
      current_user,
      defence_requests_scoped_by_policy
    )
  end

  def defence_requests_scoped_by_policy
    policy_scope(DefenceRequest)
  end
end
