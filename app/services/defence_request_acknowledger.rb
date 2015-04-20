class DefenceRequestAcknowledger
  MAX_RETRIES = 20

  def initialize(defence_request: )
    @defence_request = defence_request
    @acknowledge_attempts = 0
  end

  def acknowledge_with(cco: )
    change_state_and_associate_cco cco

    loop do
      return true if valid_with_dscc_number
      return false unless retries_left?
    end
  end

  private

  def change_state_and_associate_cco cco
    @defence_request.acknowledge
    @defence_request.cco = cco
  end

  def valid_with_dscc_number
    @acknowledge_attempts += 1
    @defence_request.dscc_number = new_dscc_number
    @defence_request.save
  end

  def retries_left?
    MAX_RETRIES >= @acknowledge_attempts
  end

  def new_dscc_number
    DsccNumberGenerator.new(defence_request: @defence_request).generate
  end
end
