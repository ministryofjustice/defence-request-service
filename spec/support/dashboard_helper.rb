module DashboardHelper
  extend ActiveSupport::Concern

  SHORT_DASHBOARD_REFRESH_SECONDS = 0.1

  included do
    around(:example, short_dashboard_refresh: true) do |example|
      old_refresh = Settings.dsds.dashboard_refresh_seconds
      Settings.dsds.dashboard_refresh_seconds = SHORT_DASHBOARD_REFRESH_SECONDS
      example.run
      Settings.dsds.dashboard_refresh_seconds = old_refresh
    end
  end

  def wait_for_dashboard_refresh
    sleep((Settings.dsds.dashboard_refresh_seconds + 1) / 1000)
  end
end
