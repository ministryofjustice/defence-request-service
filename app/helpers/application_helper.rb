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
    params[:controller] + '/js_partials/' + params[:controller] + '_' + params[:action] + '_js.html.erb'
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

  def date_formatter(date)
    date ? date.strftime("%F") : ''
  end

  def date_and_time_formatter(date)
    date ? date.strftime("%F - %R") : ''
  end

  def boolean_formatter(val)
    (val ? "&#10003;" : "&#10007;").html_safe
  end

  def dashboard_limit_formatter(val, len)
    if len == 0
      val[0].upcase
    else
      val[0..len].upcase
    end
  end
end
