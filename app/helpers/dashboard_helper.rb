module DashboardHelper

  def css_class_for_action(action, css_class)
    css_class if params[:action] == action
  end
end
