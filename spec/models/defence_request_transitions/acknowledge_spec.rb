require "rails_helper"

RSpec.describe DefenceRequestTransitions::Acknowledge, "#complete" do
  let(:defence_request) { create(:defence_request, :duty_solicitor, :queued, dscc_number: nil ) }
  let(:user) { spy(:user, uid: SecureRandom.uuid) }

  include AuthClientHelper

  let(:auth_token) { "TOKEN" }
  let(:organisation_uid) { SecureRandom.uuid }

  subject do
    described_class.new(
      defence_request: defence_request,
      user: user,
      auth_token: auth_token
    ).complete
  end

  before do
    mock_organisations([{uid: organisation_uid}])
  end

  it "transitions the defence request to acknowledge state" do
    result = subject

    expect(defence_request.cco_uid).to eql(user.uid)
    expect(defence_request.dscc_number).not_to be_empty
    expect(defence_request.organisation_uid).to eql(organisation_uid)
    expect(defence_request).to be_acknowledged
    expect(result).to be true
  end

  it "returns false if the defence_request could not be transitioned" do
    allow(defence_request).to receive(:can_acknowledge?).and_return(false)

    result = subject

    expect(defence_request).not_to be_acknowledged
    expect(result).to eq false
  end

  it "returns false if a dscc_number could not be generated" do
    expect(defence_request).to receive(:generate_dscc_number!).and_return(false)

    result = subject

    expect(defence_request).to be_acknowledged
    expect(result).to eq false
  end

  it "returns false if an organisation is not assigned" do
    mock_organisations([])

    result = subject

    expect(defence_request).to be_acknowledged
    expect(result).to eq false
  end
end
