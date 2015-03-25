module ApplicationHelper

  def flash_messages
    capture do
      flash.each do |key, msg|
        concat flash_message(key, msg)
      end
    end
  end

  def flash_message(key, msg)
    content_tag(:div, class: "#{key}-summary") do
      content_tag :p, msg
    end
  end

  def object_error_messages(active_model_messages)
    content_tag(:ul) do
      active_model_messages.each do |field_name, field_messages|
        concat errors_for_field(field_name, field_messages)
      end
    end
  end

  def errors_for_field field_name, field_messages
    content_tag :li do
      "#{t(field_name)}: #{field_messages.join(', ')}".html_safe
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
