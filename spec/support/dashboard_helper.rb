require_relative 'wait_for_ajax.rb'

module DashboardHelper
  extend ActiveSupport::Concern
  include WaitForAjax

  SHORT_DASHBOARD_REFRESH_SECONDS = 0.1

  # Some integration tests run assertions dependant on refreshing the dashboard,
  # this means there is an unavoidable sleep that needs to happen while we wait
  # for the time interval to elapse to trigger a periodic refresh. If we need
  # to do this, then we can temporarily set the refresh period to something
  # shorter than standard.
  #
  # We only want to do this in tagged specs, reducing the refresh period for all
  # tests will make things unstable if they are trying to interact with elements
  # on the dashboard whilst it is refreshing.

  included do
    around(:example, short_dashboard_refresh: true) do |example|
      old_refresh = Settings.dsds.dashboard_refresh_milliseconds
      Settings.dsds.dashboard_refresh_milliseconds = short_dashboard_refresh_milliseconds
      example.run
      Settings.dsds.dashboard_refresh_milliseconds = old_refresh
    end
  end

  def wait_for_dashboard_refresh
    sleep(Settings.dsds.dashboard_refresh_milliseconds / 1000)
    wait_for_ajax
  end

  private

  def short_dashboard_refresh_milliseconds
    SHORT_DASHBOARD_REFRESH_SECONDS * 1000
  end
end
