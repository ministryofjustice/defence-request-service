class FormGroup
  attr_reader :f, :attribute

  def initialize(form, attribute, options)
    @f = form
    @attribute = attribute
    @class = options.fetch :class, nil
    @data = options.fetch :data, nil
    @optional = options.fetch :optional, false
    build_classes!
  end

  def content(inner_body="")
    f.content_tag :div, div_options do
      content_body(inner_body)
    end
  end

  private

  def content_body(content)
    label + content
  end

  def div_options
    @div_options ||= {}.tap { |opts|
      opts[:class] = classes
      opts[:id] = id
      opts[:data] = @data
    }.compact
  end

  def classes
    @classes.join(" ")
  end

  def build_classes!
    @classes = ["form-group", @class].compact
    if error?
      @classes.delete("panel-indent")
      @classes << "error"
    end
  end

  def label
    f.label attribute, label_content
  end

  def id
    field_id = "#{parent_id}_#{attribute}".squeeze("_")
    if error?
      "#{field_id}_error"
    else
      field_id
    end
  end

  def label_content
    label_text = f.object.class.human_attribute_name attribute
    label_text += " <span class=\"aside\">(#{I18n.t("optional")})</span>".html_safe if optional?
    label = ["<span class=\"form-label-bold\">#{label_text.html_safe}</span>"]
    label << error_span if error?

    label.join(" ").html_safe
  end

  def optional?
    @optional
  end

  def error?
    !error_message.blank?
  end

  def error_message
    @error_message ||= (f.object.errors.messages.fetch attribute, []).join ", "
  end

  def error_span
    unless error_message.blank?
      f.content_tag(:span, class: "error-message") do
        error_message
      end
    end
  end

  def parent_id
    f.object_name.to_s.tr("[]","_").squeeze("_")
  end
end
