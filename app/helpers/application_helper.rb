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

  def object_error_messages(object)
    active_model_messages = object.errors.messages
    content_tag(:ul, class: "error-summary-list") do
      active_model_messages.each do |attribute, field_messages|
        parent_id = prefix_for(object)
        concat errors_for_field(parent_id, attribute, field_messages)
      end
    end
  end

  def short_date_formatter(date)
    date ? date.strftime("%-d %B") : ""
  end

  def date_formatter(date)
    date ? date.strftime("%-d %B %Y") : ""
  end

  def date_and_time_formatter(date)
    date ? date.strftime("%R %-d %B %Y") : ""
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
    content_tag(:dt, label) + " " + content_tag(:dd, value, id: options[:id], class: options[:class])
  end

  def boolean_with_explanation(val, explanation_when, explanation)
    reason = (" – #{explanation}" if val == explanation_when) || ""
    boolean_formatter(val) + reason
  end

  def tab_active_class(condition)
    "is-active" if condition
  end

  # Creates key for lookup of translation text.
  # E.g. translation_key(gender, parent_key: "defence_request", choice: "male")
  #      returns "defence_request.gender.male"
  def translation_key(attribute, options={})
    prefix = options[:parent_key]
    key = "#{prefix}.#{attribute}".squeeze(".")
    key += ".#{options[:suffix].downcase}" if options[:suffix].present?
    key.gsub!(/\.\d+\./, ".")
    key
  end

  def t_for(object, attribute)
    suffix = [attribute, object.send(attribute)].join(".")
    key = translation_key(suffix, parent_key: prefix_for(object))
    t(key)
  end

  def parent_key(parent_id)
    parent_id.gsub("_",".").sub("defence.request", "defence_request")
  end

  private

  def prefix_for(object)
    object.model_name.i18n_key.to_s
  end

  def error_id_for(parent_id, attribute)
    field_id = "#{parent_id}_#{attribute}".squeeze("_")
    "#{field_id}_error"
  end

  def errors_for_field(parent_id, attribute, field_messages)
    content_tag :li do
      content_tag :a, href: "#" + error_id_for(parent_id, attribute) do
        key = translation_key(attribute, parent_key: parent_key(parent_id), suffix: "label")
        label = t(key) rescue nil

        label = t(attribute) if label.nil? || label[/translation missing/]
        "#{label}: #{field_messages.join(", ")}".html_safe
      end
    end
  end
end
