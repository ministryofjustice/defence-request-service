module DashboardHelper

  def active_tab?(action)
    "active_tab" if params[:action] == action
  end
end
