module DashboardHelper
  def refresh_dashboard
    page.execute_script "window.jQuery.ajax({url: 'refresh_dashboard'})"
  end
end
