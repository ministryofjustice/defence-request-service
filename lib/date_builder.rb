class DateBuilder
  attr_reader :day, :month, :year

  def initialize(components = {})
    now = Date.current

    @day   = components.fetch('day', now.day)
    @month = components.fetch('month', now.month)
    @year  = components.fetch('year', now.year)
  end

  def valid?
    [day.to_s, month.to_s].any?{ |val| return false unless val =~ two_integers }
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

  def all_blank?
    [year, month, day].all?(&:blank?)
  end

  private

  def build_value
    Time.zone.local(*arguments)
  end

  def arguments
    [year, month, day].map(&:to_i)
  end

  def two_integers
    /\A\d{1,2}\z/
  end

  def four_integer_value
    /\A\d{4}\z/
  end
end
