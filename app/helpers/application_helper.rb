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

  def errors_for_field(field_name, field_messages)
    content_tag :li do
      "#{t(field_name)}: #{field_messages.join(', ')}".html_safe
    end
  end

  def js_partial
    params[:controller] + "/js_partials/" + params[:controller] + "_" + params[:action] + "_js.html.erb"
  end

  def short_date_formatter(date)
    date ? date.strftime("%-d %B") : ""
  end

  def date_formatter(date)
    date ? date.strftime("%-d %B %Y") : ""
  end

  def date_and_time_formatter(date)
    date ? date.strftime("%-d %B %Y - %R") : ""
  end

  def boolean_formatter(val)
    val ? I18n.t("yes") : I18n.t("no")
  end

  def dashboard_limit_formatter(val, len)
    if len == 0
      val[0].upcase
    else
      val[0..len].upcase
    end
  end

  def check_policy_clause(policy, clause)
    policy.respond_to?(clause) ? policy.send(clause) : false
  end

  def user_has_role?(role)
    current_user.roles.include?(role)
  end

  def display_value(label_key, value, options={})
    label = I18n.t(label_key)
    value = value.blank? ? "-" : value
    content_tag(:dt, label) + " " + content_tag(:dd, value, id: options[:id])
  end
end
