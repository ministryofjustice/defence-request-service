class DateTimeField
  include ActiveModel::Model

  attr_accessor :date, :hour, :min

  validate do
    errors.add :base, "Invalid Date or Time" if present? && value.nil?
  end

  validates :hour, :min, numericality: true
  validates_with DateValidator

  def present?
    [date, hour, min].any? &:present?
  end

  def blank?
    !present?
  end

  def value
    @value ||= begin
                 year, month, day = *[:year, :month, :day].map { |d| d.to_proc[Chronic.parse(date)] }
                 DateTime.new year.to_i, month.to_i, day.to_i, hour.to_i, min.to_i
               rescue
                 nil
               end
  end

  def self.from_persisted_value(datetime)
    DateTimeField.new.tap do |v|
      if datetime
        v.date = datetime.to_date.to_s(:full)
        v.hour = datetime.hour
        v.min = datetime.min
      end
    end
  end
end
