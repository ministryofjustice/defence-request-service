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

  def list_errors(object, field_name)
    if object.errors.any?
      unless object.errors.messages[field_name].blank?
        content_tag :ul do
          object.errors.messages[field_name].collect do |field|
            concat(content_tag(:li, field))
          end
        end
      end
    end
  end

  def js_partial
    params[:controller] + '/js_partials/' + params[:controller] + '_' + params[:action] + '_js.html.erb'
  end

  def date_formatter(date)
    date ? date.strftime("%-d %B %Y") : ''
  end

  def date_and_time_formatter(date)
    date ? date.strftime("%-d %B %Y - %R") : ''
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
