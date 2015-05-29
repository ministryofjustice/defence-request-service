class DateValidator < ActiveModel::Validator
  def validate(record)
    unless record.date.empty?
      record.errors[:date] << "is not a date" if Chronic.parse(record.date).nil?
    end
  end
end

