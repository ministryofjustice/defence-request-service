class Day

  attr_reader :name

  def initialize(name, date_proc)
    @name = name
    @date_proc = date_proc
  end

  def date
    @date_proc.call
  end

  YESTERDAY = new "yesterday", -> { Date.yesterday }
  TODAY = new "today", -> { Date.today }
  TOMORROW = new "tomorrow", -> { Date.tomorrow }
  DAY_AFTER_TOMORROW = new "day_after_tomorrow", -> { Date.tomorrow + 1 }
end
