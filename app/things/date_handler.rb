class DateHandler
  include ActiveModel::Model

  def self.model_name
    ActiveModel::Name.new(self, nil, 'DateOfBirth')
  end

  attr_accessor :day, :month, :year

  validate do
    validate_year
    validate_month
    validate_day
  end

  def value
    Date.new year.to_i, month.to_i, day.to_i
  end

  def self.from_date date
    DateHandler.new.tap do |dob|
      if date
        dob.day = date.day
        dob.month = date.month
        dob.year = date.year
      end
    end
  end

  private

  def validate_year
    errors.add field, :invalid_year if year.blank?
  end

  def validate_month
    errors.add field, :invalid_month if month.blank?
  end

  def validate_day
    errors.add field, :invalid_day if day.blank?
  end
end