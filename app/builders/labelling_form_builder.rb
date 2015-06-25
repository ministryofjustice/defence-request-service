class LabellingFormBuilder < ActionView::Helpers::FormBuilder
  include ActionView::Helpers::CaptureHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Context

  def form_group(attribute, options={}, &block)
    FormGroup.new(self, attribute, options).content capture(&block)
  end

  def text_field_input(attribute, options={}, &block)
    content = block_given? ? capture(&block) : ""
    TextField.new(self, attribute, options).content content
  end

  def text_area_input(attribute, options={}, &block)
    content = block_given? ? capture(&block) : ""
    TextArea.new(self, attribute, options).content content
  end

  # Defaults to "Yes" "No" labels on radio inputs
  def radio_button_fieldset(attribute, options={})
    RadioButtonFieldset.new(self, attribute, options).content
  end
end
