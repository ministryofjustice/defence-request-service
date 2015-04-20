class DsccNumberGenerator
  attr_reader :defence_request

  def initialize(defence_request: )
    @defence_request = defence_request
  end

  def generate
    DsccNumber.new do |dscc_number|
      dscc_number.year_and_month = year_and_month
      dscc_number.number = random_number_with_max_5_digits
    end
  end

  private

  def year_and_month
    defence_request.created_at.to_date.beginning_of_month
  end

  def random_number_with_max_5_digits
    Random.rand(10**5 -1)
  end
end
