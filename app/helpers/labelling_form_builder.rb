class LabellingFormBuilder < ActionView::Helpers::FormBuilder
  include ActionView::Helpers::CaptureHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Context

  def form_group(attribute, options={}, &block)
    a = Attribute.new(self, attribute)
    FormGroup.new(self, a, options).content capture(&block)
  end

  def text_field_input(attribute, options={}, &block)
    a = Attribute.new(self, attribute)
    content = block_given? ? capture(&block) : ""
    TextField.new(self, a, options).content content
  end

  # Defaults to "Yes" "No" labels on radio inputs
  #TODO: make legend do something
  def radio_button_fieldset(attribute, legend, options={})
    a = Attribute.new(self, attribute)
    RadioButtonFieldset.new(self, a, options).content
  end

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
      }.compact
    end

    def fieldset_options
      @fieldset_options ||= {}.tap { |opts|
        opts[:class] = classes
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

  class TextField
    attr_reader :f, :attribute

    delegate :label, :error?, :id, to: :attribute

    def initialize(form, attribute, options)
      @f = form
      @attribute = attribute
      @class =  options.fetch :class, nil
      @input_data = options.fetch :input_data, nil
      @input_class = options.fetch :input_class, nil
      build_classes!
    end

    def content(content)
      f.content_tag :div, div_options do
        labelled_text_field + content
      end
    end

    private

    def div_options
      @div_options ||= {}.tap { |opts|
        opts[:class] = classes
        opts[:id] = id
      }.compact
    end

    def input_options
      @input_options ||= {}.tap { |opts|
        opts[:class] = @input_class
        opts[:data] = @input_data
        opts[:maxlength] = max_length
      }.compact
    end

    def classes
      @classes.join(" ")
    end

    def build_classes!
      @classes = ["form-group", @class].compact
      @classes << "error" if error?
    end

    def labelled_text_field
      [label, value].join("\n").html_safe
    end

    def value
      f.text_field @attribute.attribute, input_options
    end

    def max_length
      if validator = validators.detect{ |x| x.is_a?(ActiveModel::Validations::LengthValidator) }
        validator.options[:maximum]
      end
    end

    def validators
      f.object.class.validators_on @attribute.attribute
    end
  end


  class FormGroup
    attr_reader :f, :attribute

    delegate :label, :error?, :id, to: :attribute

    def initialize(form, attribute, options)
      @f = form
      @attribute = attribute
      @class = options.fetch :class, nil
      @data = options.fetch :data, nil
      build_classes!
    end

    def content(content)
      f.content_tag :div, div_options do
        label + content
      end
    end

    private

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

  end

  class Attribute
    attr_reader :f, :attribute

    def initialize(form, attribute)
      @f = form
      @attribute = attribute
    end

    def label
      f.label @attribute, label_content
    end

    def id
      field_id = "#{parent_id}_#{@attribute}".squeeze("_")
      if error?
        "#{field_id}_error"
      else
        field_id
      end
    end

    def label_content
      label_text = f.object.class.human_attribute_name @attribute
      label = ["<span class=\"form-label-bold\">#{label_text.html_safe}</span>"]
      label << error_span if error?

      label.join(" ").html_safe
    end

    def error?
      !error_message.blank?
    end

    def error_message
      @error_message ||= f.object.errors.messages.fetch @attribute, ""
    end


    private
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
end
