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
