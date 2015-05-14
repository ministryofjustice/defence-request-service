module DashboardHelper
  def tab_class(type:)
    if params[:id]
      "active_tab" if params[:id] == type
    else
      "active_tab" if type == :active
    end
  end
end
