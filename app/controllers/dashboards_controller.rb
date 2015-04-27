class DashboardsController < BaseController
  skip_after_action :verify_authorized

  def show
    @dashboard = dashboard
  end

  def closed
    @dashboard = dashboard(:finished)
  end

  def refresh_dashboard
    @defence_requests = defence_requests_scoped_by_policy

    respond_to { |format| format.js }
  end

  private

  def dashboard(*additional_scopes)
    Dashboard.new(
      current_user,
      defence_requests_scoped_by_policy,
      additional_scopes
    )
  end

  def defence_requests_scoped_by_policy
    policy_scope(DefenceRequest)
  end
end
