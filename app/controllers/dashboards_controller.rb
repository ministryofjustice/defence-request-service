class DashboardsController < BaseController
  skip_after_action :verify_authorized

  def show
    if dashboard.user_role == "solicitor"
      @dashboard = dashboard(:not_finished)
    else
      @dashboard = dashboard
    end
  end

  def closed
    @dashboard = dashboard(:finished, :aborted)
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
