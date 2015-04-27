require_relative "../../../app/models/defence_request_transitions/abort"
require "transitions"

RSpec.describe DefenceRequestTransitions::Abort, "#complete" do
  it "transitions the defence request to the abort state" do
    defence_request = spy(:defence_request)
    user = spy(:user)
    transition_info = "transition information"

    DefenceRequestTransitions::Abort.new(
      defence_request: defence_request,
      transition_info: transition_info,
      user: user,
    ).complete

    expect(defence_request).to have_received(:abort)
    expect(defence_request).to have_received(:save!)
  end

  it "returns false if the defence_request could not be transitioned" do
    defence_request = spy(:defence_request)
    user = spy(:user)
    transition_info = "transition information"

    allow(defence_request).to receive(:can_abort?).and_return(false)

    transition = DefenceRequestTransitions::Abort.new(
      defence_request: defence_request,
      transition_info: transition_info,
      user: user,
    ).complete

    expect(defence_request).not_to have_received(:save!)
    expect(transition).to eq false
  end
end
