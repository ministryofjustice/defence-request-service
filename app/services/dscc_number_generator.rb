class DsccNumberGenerator
  attr_reader :defence_request

  def initialize(defence_request: )
    @defence_request = defence_request
  end

  def generate
    DsccNumber.new do |dscc_number|
      dscc_number.year_and_month = year_and_month
      dscc_number.number = next_monthly_number
    end
  end

  private

  def year_and_month
    defence_request.created_at.to_date.beginning_of_month
  end

  def current_monthly_number
    @current_monthly_number ||= DsccNumber.most_recent_monthly(year_and_month).pluck(:number).first || 0
  end

  def next_monthly_number
    current_monthly_number + 1
  end
end