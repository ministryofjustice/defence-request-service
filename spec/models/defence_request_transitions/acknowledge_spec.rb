require "rails_helper"

RSpec.describe DefenceRequestTransitions::Acknowledge, "#complete", :mock_auth_api do
  let(:defence_request) { create(:defence_request, :duty_solicitor, :queued, dscc_number: nil ) }
  let(:user) { create(:user) }

  let(:auth_token) { "TOKEN" }
  let(:organisation_uid) { SecureRandom.uuid }

  subject do
    described_class.new(
      defence_request: defence_request,
      user: user,
      auth_token: auth_token
    ).complete
  end

  let(:auth_api_mock_setup) do
    {
      organisations: {
        { types: [:law_firm] } => [create(:organisation, uid: organisation_uid, type: :law_firm)]
      }
    }
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

  context "something" do
    let(:auth_api_mock_setup) do
      {
        organisations: {
          { types: [:law_firm] } => []
        }
      }
    end

    it "returns false if an organisation is not assigned" do

      result = subject

      expect(defence_request).to be_acknowledged
      expect(result).to eq false
    end
  end
end
