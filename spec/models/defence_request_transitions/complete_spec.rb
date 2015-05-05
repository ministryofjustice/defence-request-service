require_relative "../../../app/models/defence_request_transitions/complete"
require "transitions"

RSpec.describe DefenceRequestTransitions::Complete, "#complete" do
  it "transitions the defence request to finish state" do
    defence_request = spy(:defence_request)

    DefenceRequestTransitions::Complete.new(
      defence_request: defence_request,
    ).complete

    expect(defence_request).to have_received(:complete)
    expect(defence_request).to have_received(:save!)
  end

  it "returns false if the defence_request could not be transitioned" do
    defence_request = spy(:defence_request)

    allow(defence_request).to receive(:can_complete?).and_return(false)

    transition = DefenceRequestTransitions::Complete.new(
      defence_request: defence_request,
    ).complete

    expect(defence_request).not_to have_received(:save!)
    expect(transition).to eq false
  end
end
