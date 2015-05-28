require "rails_helper"

RSpec.feature "Solicitors viewing their firm's requests" do
  let(:law_firm) { create :organisation, :law_firm }
  let(:solicitor_user) {
    create :solicitor_user, organisation_uids: [law_firm.uid]
  }

  let(:other_law_firm) { create :organisation, :law_firm }
  let(:other_solicitor_user) {
    create :solicitor_user, :organisation_uids [other_law_firm.uid]
  }

  let!(:aborted_defence_request) {
    create(
      :defence_request,
      :aborted,
      solicitor_uid: solicitor_user.uid,
      organisation_uid: solicitor_user.organisation_uids.first
    )
  }

  let(:auth_api_mock_setup) do
    {
      organisation: {
        law_firm.uid => law_firm,
        other_law_firm.uid => other_law_firm
      }
    }
  end

  specify "can see defence requests", :mock_auth_api do
    firms_defence_request =
      create(
        :defence_request,
        :aborted,
        solicitor_uid: nil,
        organisation_uid: solicitor_user.organisation_uids.first,
        offences: "Arson"
    )
    other_firms_defence_request =
      create(
        :defence_request,
        :aborted,
        solicitor_uid: nil,
        organisation_uid: other_solicitor_user.organisation_uids.first,
        offences: "Extortion"
    )

    login_with solicitor_user
    click_link "Closed"

    expect(page).to     have_content firms_defence_request.offences
    expect(page).to_not have_content other_firms_defence_request.offences
  end
end
