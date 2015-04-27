require_relative "../../../app/models/defence_request_transitions/queue"
require "transitions"

RSpec.describe DefenceRequestTransitions::Queue, "#complete" do
  it "transitions the defence request to queue state" do
    defence_request = spy(:defence_request)
    user = spy(:user)
    transition_to = "queue"

    DefenceRequestTransitions::Queue.new(
      defence_request: defence_request,
      transition_to: transition_to,
      user: user,
    ).complete

    expect(defence_request).to have_received(:queue)
    expect(defence_request).to have_received(:save!)
  end

  it "returns false if the defence_request could not be transitioned" do
    defence_request = spy(:defence_request)
    user = spy(:user)
    transition_to = "queue"

    allow(defence_request).to receive(:can_queue?).and_return(false)

    transition = DefenceRequestTransitions::Queue.new(
      defence_request: defence_request,
      transition_to: transition_to,
      user: user,
    ).complete

    expect(defence_request).not_to have_received(:save!)
    expect(transition).to eq false
  end
end
