class DsccNumber < ActiveRecord::Base

  def self.current_monthly_number
    where(year_and_month: current_year_and_month).order('number desc').limit(1).pluck(:number).first || 0
  end

  def self.next_monthly_number
    current_monthly_number + 1
  end

  def self.current_year_and_month
    Time.now.to_date.beginning_of_month
  end

  def self.generate
    new do |dscc_number|
      dscc_number.year_and_month = current_year_and_month
      dscc_number.number = next_monthly_number
    end
  end

  validates_uniqueness_of :number, scope: [:year_and_month]
  validates_uniqueness_of :defence_request_id

  def to_s
    [year_and_month.strftime("%y%m"), number.to_s.rjust(5, "0"), extension].join ""
  end
end
