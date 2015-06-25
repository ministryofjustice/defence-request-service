require "rails_helper"

class MockTemplate
  include ActionView::Helpers::FormHelper
  include ActionView::Helpers::FormOptionsHelper

  attr_accessor :output_buffer

  def translation_key(attribute, options={})
    "defence_request.gender"
  end

  def parent_key(parent_id)
    "defence_request"
  end
end

RSpec::Matchers.define :only_show_errors_inside do |expected, opts|
  opts = opts || {}
  opts = { error_css: "span.error-message" }.merge(opts)
  match do |actual|
    doc                             = Nokogiri::HTML(actual)
    @count_of_all_error_messages    = doc.css(opts[:error_css]).count
    count_of_correct_error_messages = doc.css(opts[:error_css]).count{ |elem| elem.parent.name == expected.to_s }
    @total_failures                 = @count_of_all_error_messages - count_of_correct_error_messages
    (@total_failures == 0) && (@count_of_all_error_messages > 0)
  end
  failure_message do |actual|
    if @total_failures > 0
      "expected #{pluralize(@count_of_all_error_messages, "error")} to appear inside a #{expected} tag. #{@total_failures} did not."
    elsif @count_of_all_error_messages <= 0
      "expected error messages, but did not find any."
    end
  end
end

RSpec::Matchers.define :contain_css_selectors do |expected_elements|
  match do |actual|
    doc     = Nokogiri::HTML(actual)
    @errors = []
    [expected_elements].flatten.each do |element|
      @errors << "expected `#{element}`, but did not find it" if doc.css(element).blank?
    end
    @errors.empty?
  end
  failure_message do |actual|
    "generated form had the following errors: " + @errors.compact.join(", ")
  end
end

RSpec::describe "LabellingFormBuilder", type: :helper do

  let(:defence_request)   { double("model", class: double("class").as_null_object).as_null_object }
  let(:template) { MockTemplate.new }
  let(:form)     { LabellingFormBuilder.new("defence_request", defence_request, template, { }) }

  describe "#radio_button_field_set" do
    let(:fieldset) {
      form.radio_button_fieldset :gender,
      class: "radio",
      choice: [ "male", "female", "transgender", "unspecified" ]
    }

    before do
      messages = double("error_messages", messages: { gender: ["can't be blank"] })
      allow(defence_request).to receive(:errors) { messages }
    end

    it "outputs the correct form element" do
      expect(fieldset).to contain_css_selectors(
        "fieldset.radio",
        "fieldset legend",
        "input[type=radio, id=gender-male]",
        "input[type=radio, id=gender-female]",
        "input[type=radio, id=gender-transgender]",
        "input[type=radio, id=gender-unspecified]"
      )
    end

    it "shows errors inside the legend" do
      expect(fieldset).to only_show_errors_inside(:legend, error_css: "legend span.error-message")
    end
  end

  describe "#text_field_input" do
    let(:options) { {} }
    let(:row) { form.text_field_input(:detainee_name, options) }

    it "outputs the correct form element" do
      expect(row).to contain_css_selectors([".form-group input[type=text]", ".form-group label"])
    end

    it "shows errors inside the label" do
      messages = double("error_messages", messages: { detainee_name: ["date cannot be blank"] })
      expect(defence_request).to receive(:errors).at_least(:once).and_return(messages)
      expect(row).to only_show_errors_inside(:label, error_css: "label span.error-message")
    end

    context "when multiline is set" do
      let(:options) { { multiline: 3 } }
      it "renders textarea" do
        expect(row).to match(%r{<textarea[^>]*>})
      end
    end

    context "when multiline is not set" do
      it "renders input type=\"text\"" do
        expect(row).to match(%r{^<input[^>]+type="text"[^>]*>})
      end
    end
  end

  describe "#form_group" do
    let(:row) { form.form_group(:date_of_birth) {} }

    it "outputs the correct form element" do
      expect(row).to contain_css_selectors([".form-group", ".form-group label"])
    end

    it "shows errors inside the label" do
      messages = double("error_messages", messages: { date_of_birth: ["date cannot be blank"] })
      expect(defence_request).to receive(:errors).at_least(:once).and_return(messages)
      expect(row).to only_show_errors_inside(:label, error_css: "label span.error-message")
    end
  end

end
