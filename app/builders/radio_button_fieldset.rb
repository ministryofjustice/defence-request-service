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

  def build_classes!
    super
    @classes << "radio"
  end

  def value(choice)
    f.radio_button attribute, choice
  end

  def fieldset_options
    @fieldset_options ||= {}.tap { |opts|
      opts[:class] = fieldset_classes
    }.compact
  end

  def fieldset_classes
    @classes - ["panel-indent", "error"]
  end

  def inner_div_options
    @inner_div_options ||= {}.tap { |opts|
      opts[:class] ||=  "inline"
    }.compact
  end

  def fieldset_tag(options={}, &block)
    f.content_tag :fieldset, options do
      f.content_tag(:legend, label_content) + block.call if block_given?
    end
  end
end
