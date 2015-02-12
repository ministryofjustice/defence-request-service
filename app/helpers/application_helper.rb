module ApplicationHelper

  def flash_messages(opts = {})
    flash.to_h.slice('notice', 'alert').each do |msg_type, message|
      concat(content_tag(:div, message, class: "#{msg_type}-summary") do
        content_tag(:p, message) do
          concat safe_join(Array(message), tag(:br))
        end
      end)
    end
    nil
  end

  def js_partial
    params[:controller] + '/' + params[:controller] + '_' + params[:action] + '_js.html.erb'
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
