class DateTimeField
  include ActiveModel::Model

  attr_accessor :date, :hour, :min

  validate do
    errors.add :base, error_message_lookup_proc[:invalid] if present? && value.nil?
  end

  def present?
    [date, hour, min].any? &:present?
  end

  def blank?
    !present?
  end

  def value
    @value ||= begin
                 year, month, day = *[:year, :month, :day].map { |d| d.to_proc[Chronic.parse(date)] }
                 min, hour = *[self.min, self.hour].map(&maybe.curry[to_integer])
                 year && month && day && hour && min && DateTime.new(year.to_i, month.to_i, day.to_i, hour.to_i, min.to_i)
               rescue
                 nil
               end
  end

  def self.from_persisted_value(datetime)
    DateTimeField.new.tap do |v|
      if datetime
        v.date = datetime.to_date.to_s(:full)
        v.hour = "%02d" % datetime.hour
        v.min = "%02d" % datetime.min
      end
    end
  end

  def set_error_message_lookup_proc!(error_proc)
    @error_message_lookup_proc = error_proc
  end

  private

  def error_message_lookup_proc
    @error_message_lookup_proc ||= ->(a){ a }
  end

  def maybe
    ->(f, a) { f[a] if a }
  end

  def to_integer
    ->(s) { s if to_time_string(s.to_i) == to_time_string(s.to_i.to_s) && s =~ /^[0-9]+$/ }
  end

  def to_time_string(s)
    "%02d" % s
  end

end
