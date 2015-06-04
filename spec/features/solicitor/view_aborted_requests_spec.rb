require "rails_helper"

RSpec.feature "Solicitors viewing aborted requests" do
  let(:law_firm) { create :organisation, :law_firm }

  let(:solicitor_user) {
    create :solicitor_user, organisation_uids: [law_firm.uid]
  }

  let!(:aborted_defence_request) {
    create(
      :defence_request,
      :aborted,
      solicitor_uid: solicitor_user.uid,
      organisation_uid: solicitor_user.organisation_uids.first
    )
  }

  let(:auth_api_mock_setup) {
    {
      organisation: {
        law_firm.uid => law_firm
      }
    }
  }

  specify "can see 'aborted' defence requests", :mock_auth_api do
    login_with solicitor_user
    click_link "Closed"
    click_link "Case details for #{aborted_defence_request.dscc_number}"

    expect(page).
      to have_content "This case has been aborted for the following reason"
    expect(page).to have_content aborted_defence_request.reason_aborted
  end
end
