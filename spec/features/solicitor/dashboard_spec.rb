require "rails_helper"

RSpec.feature "Solicitors viewing their dashboard" do
  include DashboardHelper

  specify "can only see requests that they have accepted" do
    solicitor_user = create :solicitor_user
    accepted_defence_request = create(
      :defence_request,
      :accepted,
      solicitor_uid: solicitor_user.uid,
      organisation_uid: solicitor_user.organisation_uids.first,
      offences: "Arson"
    )
    not_accepted_defence_request = create :defence_request, offences: "Extortion"

    login_with solicitor_user

    expect(page).to have_content accepted_defence_request.offences
    expect(page).to_not have_content not_accepted_defence_request.offences
  end

  context "when the dashboard refreshes to update defence request information" do
    specify "they can still only see requests the they have accepted", js: true, short_dashboard_refresh: true do
      solicitor_user = create :solicitor_user
      accepted_defence_request = create(
        :defence_request,
        :accepted,
        solicitor_uid: solicitor_user.uid,
        organisation_uid: solicitor_user.organisation_uids.first
      )
      acknowledged_defence_request = create :defence_request, :acknowledged

      login_with solicitor_user

      expect(page).to have_content(accepted_defence_request.detainee_name)
      expect(page).to_not have_content(acknowledged_defence_request.detainee_name)

      refresh_dashboard

      expect(page).to have_content(accepted_defence_request.detainee_name)
      expect(page).to_not have_content(acknowledged_defence_request.detainee_name)
    end
  end
end
