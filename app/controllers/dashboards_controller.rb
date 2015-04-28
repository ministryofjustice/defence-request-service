class DashboardsController < BaseController
  skip_after_action :verify_authorized
  before_filter :set_dashboard_count, only: [:show, :closed]

  def show
    @dashboard = active_dashboard
  end

  def closed
    @dashboard = closed_dashboard
  end

  def refresh_dashboard
    @defence_requests = defence_requests_scoped_by_policy

    respond_to { |format| format.js }
  end

  private

  def active_dashboard
    if dashboard.user_role == "solicitor"
      @_active_dashboard ||= dashboard(:not_finished)
    else
      @_active_dashboard ||= dashboard
    end
  end

  def closed_dashboard
    @_closed_dashboard ||= dashboard(:finished, :aborted)
  end

  def set_dashboard_count
    @active_count ||= active_dashboard.defence_requests.count
    @closed_count ||= closed_dashboard.defence_requests.count
  end

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
