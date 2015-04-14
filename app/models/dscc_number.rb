class DsccNumber < ActiveRecord::Base
  has_one :defence_request

  validates_uniqueness_of :number, scope: [:year_and_month]

  scope :most_recent_monthly, ->(year_and_month) {
    where(year_and_month: year_and_month).order('number desc').limit(1)
  }

  def to_s
    "%s%05d%s" % [prefix, number, extension]
  end

  private

  def prefix
    year_and_month.strftime("%y%m")
  end
end