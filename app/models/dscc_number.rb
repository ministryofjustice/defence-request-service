class DsccNumber < ActiveRecord::Base

  def self.current_monthly_number
    where(year_and_month: current_year_and_month).order('number desc').limit(1).pluck(:number).first || 0
  end

  def self.next_monthly_number
    current_monthly_number + 1
  end

  def self.current_year_and_month
    Time.current.to_date.beginning_of_month
  end

  def self.generate
    new do |dscc_number|
      dscc_number.year_and_month = current_year_and_month
      dscc_number.number = next_monthly_number
    end
  end

  has_one :defence_request

  validates_uniqueness_of :number, scope: [:year_and_month]

  def to_s
    "%s%05d%s" % [prefix, number, extension]
  end

  private

  def prefix
    year_and_month.strftime("%y%m")
  end
end
