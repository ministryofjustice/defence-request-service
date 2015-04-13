require "rails_helper"

RSpec.feature "Solicitors viewing their dashboard" do
  include DashboardHelper

  specify "can only see requests that they have accepted" do
    solicitor_user = create :solicitor_user
    accepted_defence_request = create(
      :defence_request,
      :accepted,
      solicitor_uid: solicitor_user.uid
    )
    not_accepted_defence_request = create :defence_request

    login_with_role "solicitor", solicitor_user.uid

    expect(page).to have_content accepted_defence_request.solicitor_name
    expect(page).to_not have_content not_accepted_defence_request.solicitor_name
  end

  context "when the dashboard refreshes to update defence request information" do
    specify "they can still only see requests the they have accepted", js: true, short_dashboard_refresh: true do
      solicitor_user = create :solicitor_user
      accepted_defence_request = create(
        :defence_request,
        :accepted,
        solicitor_uid: solicitor_user.uid
      )
      acknowledged_defence_request = create :defence_request, :acknowledged

      login_with_role "solicitor", solicitor_user.uid

      expect(page).to have_content(accepted_defence_request.detainee_name)
      expect(page).to_not have_content(acknowledged_defence_request.detainee_name)

      wait_for_dashboard_refresh

      expect(page).to have_content(accepted_defence_request.detainee_name)
      expect(page).to_not have_content(acknowledged_defence_request.detainee_name)
    end
  end
end
