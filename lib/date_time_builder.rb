class DateTimeBuilder
  attr_reader :day, :month, :year
  attr_reader :hour, :min, :sec

  def initialize(components = {})
    now = Time.current

    @day   = components.fetch('day', now.day)
    @month = components.fetch('month', now.month)
    @year  = components.fetch('year', now.year)
    @hour  = components.fetch('hour', now.hour)
    @min   = components.fetch('min', now.min)
    @sec   = components.fetch('sec', 0)
  end

  def valid?
    [day.to_s, month.to_s, hour.to_s, min.to_s, sec.to_s].any?{ |val| return false unless val =~ two_integers }
    return false unless year.to_s =~ four_integer_value
    true
  end

  def value
    if valid?
      begin
        build_value
      rescue ArgumentError => e
        false
      end
    end
  end

  def any_present?
    !all_blank?
  end

  def year?
    year.present?
  end

  def month?
    month.present?
  end

  def day?
    day.present?
  end

  def hour?
    hour.present?
  end

  def min?
    min.present?
  end

  def all_blank?
    [year, month, day, hour, min].all?(&:blank?)
  end

  private

  def build_value
    Time.zone.local(*arguments)
  end

  def arguments
    [year, month, day, hour, min, sec].map(&:to_i)
  end

  def two_integers
    /\A\d{1,2}\z/
  end

  def four_integer_value
    /\A\d{4}\z/
  end
end
