class RadioButtonFieldset
  attr_reader :f, :attribute

  delegate :label_content, :error?, :id, to: :attribute

  def initialize(form, attribute, options)
    @f = form
    @attribute = attribute
    @class = options.fetch :class, nil
    @options_class = (@class || "")[/inline/] ? "inline" : "options"
    @choice = options.fetch :choice, ["Yes", "No"]
    build_classes!
  end

  def content
    f.content_tag :div, div_options do
      fieldset_tag fieldset_options do
        f.content_tag :div, inner_div_options do
          radios = @choice.map do |choice|
            radio_button_row choice
          end
          radios.join("\n").html_safe
        end
      end
    end
  end

  private

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
    f.radio_button @attribute.attribute, choice
  end

  def div_options
    @div_options ||= {}.tap { |opts|
      opts[:class] = classes
      opts[:id] = id
    }.compact
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

  def classes
    @classes.join(" ")
  end

  def build_classes!
    @classes = ["form-group", @class].compact
    @classes << "error" if error?
  end

  def fieldset_tag(options={}, &block)
    (f.tag(:fieldset, options, true) +
     f.content_tag(:legend, label_content) +
     (block_given? ? f.capture(&block) : "") +
     "</fieldset>".html_safe).html_safe
  end
end
