require "rails_helper"

RSpec.feature "Solicitors viewing their dashboard" do
  include DashboardHelper

  let(:dashboard_page) { SolicitorDashboardPage.new }

  let!(:solicitor_user) { create :solicitor_user }
  let!(:accepted_defence_request) do
    create(
      :defence_request,
      :accepted,
      solicitor_uid: solicitor_user.uid,
      organisation_uid: solicitor_user.organisation_uids.first,
      offences: "Arson"
    )
  end

  before do
    create :defence_request, offences: "Extortion"

    login_with solicitor_user
  end

  specify "can only see requests that they have accepted" do
    expect(dashboard_page).to have_defence_requests(count: 1)
    expect(dashboard_page.defence_requests.first).to match_defence_request(accepted_defence_request)
  end

  context "when the dashboard refreshes to update defence request information" do
    specify "they can still only see requests the they have accepted", js: true do
      expect(dashboard_page).to have_defence_requests(count: 1)
      expect(dashboard_page.defence_requests.first).to match_defence_request(accepted_defence_request)

      refresh_dashboard

      # Fixme this should use more appropriate way of waiting, but for a demo this is sufficient
      sleep(0.1)

      expect(dashboard_page).to have_defence_requests(count: 1)
      expect(dashboard_page.defence_requests.first).to match_defence_request(accepted_defence_request)
    end
  end
end
