require_relative "../../../app/models/defence_request_transitions/accept"
require "securerandom"
require "transitions"

RSpec.describe DefenceRequestTransitions::Accept, "#complete" do
  it "transitions the defence request to accept state" do
    defence_request = spy(:defence_request)
    user = spy(:user, uid: SecureRandom.uuid)

    DefenceRequestTransitions::Accept.new(
      defence_request: defence_request,
      user: user,
    ).complete

    expect(defence_request).to have_received(:cco_uid=).with(user.uid)
    expect(defence_request).to have_received(:accept)
    expect(defence_request).to have_received(:save!)
  end

  it "returns false if the defence_request could not be transitioned" do
    defence_request = spy(:defence_request)
    user = spy(:user, uid: SecureRandom.uuid)

    allow(defence_request).to receive(:can_accept?).and_return(false)

    transition = DefenceRequestTransitions::Accept.new(
      defence_request: defence_request,
      user: user,
    ).complete

    expect(defence_request).to have_received(:cco_uid=).with(user.uid)
    expect(defence_request).not_to have_received(:save!)
    expect(transition).to eq false
  end
end
