class AddSolicitorTimeOfArrival
  attr_accessor :defence_request, :solicitor_time_of_arrival

  def initialize(defence_request, solicitor_time_of_arrival)
    @defence_request = defence_request
    @solicitor_time_of_arrival = solicitor_time_of_arrival
  end

  def call
    defence_request.update_attributes(solicitor_time_of_arrival)
  end
end
