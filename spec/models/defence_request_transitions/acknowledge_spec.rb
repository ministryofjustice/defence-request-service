require_relative "../../../app/models/defence_request_transitions/acknowledge"
require "securerandom"
require "transitions"

RSpec.describe DefenceRequestTransitions::Acknowledge, "#complete" do
  it "transitions the defence request to acknowledge state" do
    defence_request = spy(:defence_request)
    user = spy(:user, uid: SecureRandom.uuid)

    DefenceRequestTransitions::Acknowledge.new(
      defence_request: defence_request,
      user: user,
    ).complete

    expect(defence_request).to have_received(:cco_uid=).with(user.uid)
    expect(defence_request).to have_received(:acknowledge)
    expect(defence_request).to have_received(:save!)
  end

  it "returns false if the defence_request could not be transitioned" do
    defence_request = spy(:defence_request)
    user = spy(:user, uid: SecureRandom.uuid)

    allow(defence_request).to receive(:can_acknowledge?).and_return(false)

    transition = DefenceRequestTransitions::Acknowledge.new(
      defence_request: defence_request,
      user: user,
    ).complete

    expect(defence_request).to have_received(:cco_uid=).with(user.uid)
    expect(defence_request).not_to have_received(:save!)
    expect(transition).to eq false
  end

  it "returns false if a dscc_number could not be generated" do
    defence_request = spy(:defence_request)
    user = spy(:user, uid: SecureRandom.uuid)

    expect(defence_request).to receive(:generate_dscc_number!).and_return(false)

    transition = DefenceRequestTransitions::Acknowledge.new(
      defence_request: defence_request,
      user: user,
    ).complete

    expect(defence_request).to have_received(:cco_uid=).with(user.uid)
    expect(defence_request).to have_received(:save!)
    expect(transition).to eq false
  end
end
