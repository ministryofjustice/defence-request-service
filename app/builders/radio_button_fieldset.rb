class RadioButtonFieldset < FormGroup

  def initialize(form, attribute, options)
    @choice = options.fetch :choice, ["true", "false"]
    super
  end

  private

  def content_body(*)
    fieldset_tag fieldset_options do
      f.content_tag :div, inner_div_options do
        radios = @choice.map do |choice|
          radio_button_row choice
        end
        radios.join("\n").html_safe
      end
    end
  end

  def radio_button_row(choice)
    label = I18n.t choice
    id = value(choice)[/id="([^"]+)"/,1]

    f.content_tag(:div, class: "option") do
      f.content_tag(:label, for: id) do
        [value(choice), label].compact.join("\n").html_safe
      end
    end
  end

  def value(choice)
    f.radio_button attribute, choice
  end

  def fieldset_options
    @fieldset_options ||= {}.tap { |opts|
      opts[:class] = classes.gsub "error", ""
    }.compact
  end

  def inner_div_options
    @inner_div_options ||= {}.tap { |opts|
      opts[:class] ||= @options_class
    }.compact
  end

  def fieldset_tag(options={}, &block)
    (f.tag(:fieldset, options, true) +
     f.content_tag(:legend, label_content) +
     (block_given? ? f.capture(&block) : "") +
     "</fieldset>".html_safe).html_safe
  end
end
