require_relative "../../../app/models/defence_request_transitions/finish"
require "transitions"

RSpec.describe DefenceRequestTransitions::Finish, "#complete" do
  it "transitions the defence request to finish state" do
    defence_request = spy(:defence_request)
    user = spy(:user)
    transition_to = "finish"

    DefenceRequestTransitions::Finish.new(
      defence_request: defence_request,
      transition_to: transition_to,
      user: user,
    ).complete

    expect(defence_request).to have_received(:finish)
    expect(defence_request).to have_received(:save!)
  end

  it "returns false if the defence_request could not be transitioned" do
    defence_request = spy(:defence_request)
    user = spy(:user)
    transition_to = "finish"

    allow(defence_request).to receive(:finish).and_raise(Transitions::InvalidTransition)

    transition = DefenceRequestTransitions::Finish.new(
      defence_request: defence_request,
      transition_to: transition_to,
      user: user,
    ).complete

    expect(defence_request).not_to have_received(:save!)
    expect(transition).to eq false
  end
end
