require_relative "../../../app/models/defence_request_transitions/builder"
require_relative "../../support/example_test_strategy"
require "active_support/inflector"

RSpec.describe DefenceRequestTransitions::Builder, "#build" do
  it "builds the correct strategy based on the request transition" do
    transition_params = { transition_to: "example" }

    strategy = DefenceRequestTransitions::Builder.new(transition_params).build

    expect(strategy).to be_an_instance_of DefenceRequestTransitions::Example
  end
end
