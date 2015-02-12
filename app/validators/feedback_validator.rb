class FeedbackValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if record.closed? && value.blank?
      record.errors.add(attribute, :blank)
    end
  end
end
