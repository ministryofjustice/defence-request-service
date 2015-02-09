module ApplicationHelper
  include ActiveModel

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

