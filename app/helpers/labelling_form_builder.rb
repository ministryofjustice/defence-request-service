class LabellingFormBuilder < ActionView::Helpers::FormBuilder

  include ActionView::Helpers::CaptureHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Context

  def form_group(attribute, options={}, &block)
    FormGroup.new(@object, @object_name, attribute, options).content capture(&block)
  end

  def text_field_input(attribute, options={}, &block)
    content = block_given? ? capture(&block) : ""
    value_proc = self.method(:text_field)
    TextField.new(@object, @object_name, attribute, options, value_proc).content content
  end

  # Defaults to "Yes" "No" labels on radio inputs
  def radio_button_fieldset(attribute, legend, options={})
    value_proc = self.method(:radio_button)
    RadioButtonFieldset.new(@object, @object_name, attribute, legend, options, value_proc).content
  end

  class RadioButtonFieldset
    include ActionView::Helpers::CaptureHelper
    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::FormTagHelper

    attr_accessor :output_buffer

    def initialize(object, object_name, attribute, legend, options, radio_button_proc)
      @object_name = object_name
      @object = object
      @attribute = attribute
      @legend = legend
      @class = options.fetch :class, nil
      @options_class = (@class || "")[/inline/] ? "inline" : "options"
      @choice = options.fetch :choice, ["Yes", "No"]
      @radio_button_proc = radio_button_proc
      build_classes!
    end

    def content
      content_tag :div, div_options do
        fieldset_tag fieldset_options do
          content_tag :div, inner_div_options do
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

      content_tag(:div, class: "option") do
        content_tag(:label, for: id) do
          [value(choice),  label].compact.join("\n").html_safe
        end
      end
    end

    def value(choice)
      @radio_button_proc.call @attribute, choice
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

    def error_span
      unless error_message.blank?
        content_tag(:span, class: "error-message") do
          error_message
        end
      end
    end

    def fieldset_tag(options={}, &block)
      (tag(:fieldset, options, true) +
       content_tag(:legend, label_content) +
       (block_given? ? capture(&block) : "") +
       "</fieldset>").html_safe
    end

    def label
      label_tag id, label_content
    end

    def id
      field_id = "#{parent_id}_#{@attribute}".squeeze("_")
      if error?
        "#{field_id}_error"
      else
        field_id
      end
    end

    def parent_id
      @object_name.to_s.tr("[]","_").squeeze("_")
    end

    def label_content
      label_text = @object.class.human_attribute_name @attribute
      label = ["<span class=\"form-label-bold\">#{label_text.html_safe}</span>"]
      label << error_span if error?

      label.join(" ").html_safe
    end

    def error?
      !error_message.blank?
    end

    def error_message
      @error_message ||= @object.errors.messages.fetch @attribute, ""
    end
  end

  class TextField
    include ActionView::Helpers::CaptureHelper
    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::FormTagHelper

    attr_accessor :output_buffer

    def initialize(object, object_name, attribute, options, value_proc)
      @object_name = object_name
      @object = object
      @attribute = attribute
      @class =  options.fetch :class, nil
      @input_data = options.fetch :input_data, nil
      @input_class = options.fetch :input_class, nil
      @value_proc = value_proc
      build_classes!
    end

    def content(content)
      content_tag :div, div_options do
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

    def label
      label_tag id, label_content
    end

    def label_content
      label_text = @object.class.human_attribute_name @attribute
      label = ["<span class=\"form-label-bold\">#{label_text.html_safe}</span>"]
      label << error_span if error?

      label.join(" ").html_safe
    end

    def labelled_text_field
      [label, value].join("\n").html_safe
    end

    def value
      @value_proc.call @attribute, input_options
    end

    def max_length
      if validator = validators.detect{ |x| x.is_a?(ActiveModel::Validations::LengthValidator) }
        validator.options[:maximum]
      end
    end

    def validators
      @object.class.validators_on @attribute
    end

    def id
      field_id = "#{parent_id}_#{@attribute}".squeeze("_")
      if error?
        "#{field_id}_error"
      else
        field_id
      end
    end

    def parent_id
      @object_name.to_s.tr("[]","_").squeeze("_")
    end

    def error?
      !error_message.blank?
    end

    def error_message
      @error_message ||= @object.errors.messages.fetch @attribute, ""
    end

    def error_span
      unless error_message.blank?
        content_tag(:span, class: "error-message") do
          error_message
        end
      end
    end

  end


  class FormGroup
    include ActionView::Helpers::CaptureHelper
    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::FormTagHelper

    attr_accessor :output_buffer

    def initialize(object, object_name, attribute, options)
      @object_name = object_name
      @object = object
      @attribute = attribute
      @class = options.fetch :class, nil
      @data = options.fetch :data, nil
      build_classes!
    end

    def content(content)
      content_tag :div, div_options do
        label + content
      end
    end

    private

    def label
      label_tag @attribute, label_content
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

    def error?
      !error_message.blank?
    end

    def error_message
      @error_message ||= @object.errors.messages.fetch @attribute, ""
    end

    def label_content
      label_text = @object.class.human_attribute_name @attribute
      label = ["<span class=\"form-label-bold\">#{label_text.html_safe}</span>"]
      label << error_span if error?

      label.join(" ").html_safe
    end

    def error_span
      unless error_message.blank?
        content_tag(:span, class: "error-message") do
          error_message
        end
      end
    end

    def id
      field_id = "#{parent_id}_#{@attribute}".squeeze("_")
      if error?
        "#{field_id}_error"
      else
        field_id
      end
    end

    def parent_id
      @object_name.to_s.tr("[]","_").squeeze("_")
    end
  end
end
