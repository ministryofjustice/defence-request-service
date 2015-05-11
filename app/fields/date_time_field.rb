class DateTimeField
  include ActiveModel::Model

  attr_accessor :day, :month, :year, :hour, :min

  validate do
    begin
      DateTime.new year.to_i, month.to_i, day.to_i, hour.to_i, min.to_i
    rescue => e
      errors.add :base, "Invalid Date or Time"
    end
  end

  validates :day, :month, :year, :hour, :min, numericality: true

  def present?
    [year, month, day, hour, min].any? &:present?
  end

  def blank?
    !present?
  end

  def value
    DateTime.new year.to_i, month.to_i, day.to_i, hour.to_i, min.to_i rescue nil
  end

  def self.from_persisted_value(datetime)
    DateTimeField.new.tap do |v|
      if datetime
        v.day = datetime.day
        v.month = datetime.month
        v.year = datetime.year
        v.hour = datetime.hour
        v.min = datetime.min
      end
    end
  end
end
