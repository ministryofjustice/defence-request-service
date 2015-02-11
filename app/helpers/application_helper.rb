module ApplicationHelper

  def js_partial
    params[:controller] + '/' + params[:controller] + '_' + params[:action] + '.js.erb'
  end

  def is_dashboard?
    is_controller?('defence_requests') && is_action?('index')
  end

  def is_controller?(controller)
    params[:controller] == controller
  end

  def is_action?(action)
    params[:action] == action
  end
end
