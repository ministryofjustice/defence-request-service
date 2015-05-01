RSpec::Matchers.define :match_defence_request do |expected|
  match do |actual|
    @errors = []

    @errors << :time_of_arrival unless actual.time_of_arrival.text == expected.time_of_arrival.to_s(:time)
    @errors << :detainee_name unless actual.detainee_name.text == expected.detainee_name
    @errors << :offences unless actual.offences.text == expected.offences
    @errors << :dscc unless actual.dscc.text == expected.dscc_number

    @errors.empty?
  end

  failure_message do |_|
    "some defence request properties are not matching: #{@errors.join(", ")}"
  end
end