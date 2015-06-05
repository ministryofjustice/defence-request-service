class Day

  attr_reader :name, :date

  def initialize(name, date)
    @name = name
    @date = date
  end

  YESTERDAY = new "yesterday", Date.yesterday
  TODAY = new "today", Date.today
  TOMORROW = new "tomorrow", Date.tomorrow
end
