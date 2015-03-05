class DateTimeHandler
  include ActiveModel::Model

  def self.model_name
    ActiveModel::Name.new(self, nil, 'DateOfBirth')
  end

  attr_accessor :day, :month, :year, :hour, :min

  validate do
    validate_year
    validate_month
    validate_day
    validate_hour
    validate_min
  end

  def value
    DateTime.new year.to_i, month.to_i, day.to_i, hour.to_i, min.to_i rescue nil
  end

  def self.from_date_time datetime
    DateTimeHandler.new.tap do |v|
      if datetime
        v.day = datetime.day
        v.month = datetime.month
        v.year = datetime.year
      end
    end
  end

  private


  def validate_year
    errors.add :invalid_year, 'THIS IS RUBBISH' if year.blank?
  end

  def validate_month
    errors.add :invalid_month, 'THIS IS RUBBISH' if month.blank?
  end

  def validate_day
    errors.add :invalid_day, 'THIS IS RUBBISH' if day.blank?
  end

  def validate_hour
    errors.add :invalid_hour, 'THIS IS RUBBISH' if hour.blank?
  end

  def validate_min
    errors.add :invalid_min, 'THIS IS RUBBISH' if min.blank?
  end
end