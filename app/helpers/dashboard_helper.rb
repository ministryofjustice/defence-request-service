module DashboardHelper
  def tab_class(type:)
    "active_tab" unless params[:id] && params[:id] != type
  end
end
