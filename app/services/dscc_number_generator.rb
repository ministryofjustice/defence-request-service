class DsccNumberGenerator
  attr_reader :defence_request

  def initialize(defence_request: )
    @defence_request = defence_request
  end

  def generate
    DsccNumber.new do |dscc_number|
      dscc_number.year_and_month = year_and_month
    end
  end

  private

  def year_and_month
    defence_request.created_at.to_date.beginning_of_month
  end
end
