module DateHelpers
  def date_then_as_hash
    build_date_hash_from Time.at(1423757676).to_datetime
  end

  def date_now_as_hash
    build_date_hash_from DateTime.current
  end

  def twenty_one_years_ago_as_hash
    build_date_hash_from DateTime.current - 21.years
  end

  def build_date_hash_from(date)
    {
      day: date.day,
      month: date.month,
      year: date.year,
      min: date.minute,
      hour: date.hour
    }
  end
end
