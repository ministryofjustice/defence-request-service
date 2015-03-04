require "rails_helper"

RSpec.feature "Solicitors viewing their dashboard" do
  include DashboardHelper

  let!(:solicitor_dr) { create(:defence_request, :accepted) }
  let!(:other_solicitor_dr) { create(:defence_request, :accepted) }
  let!(:other_solicitor) { create(:solicitor_user) }
  let!(:solicitor_dr_not_accepted) { create(:defence_request, :opened, dscc_number: "98765", solicitor: solicitor_dr.solicitor) }
  let!(:created_dr) { create(:defence_request, :created, dscc_number: "98765", solicitor: solicitor_dr.solicitor) }

  before :each do
    login_as_user(solicitor_dr.solicitor.email)
  end

  specify "can only see requests that they have accepted" do
    visit defence_requests_path
    within ".accepted-defence-request" do
      expect(page).to have_content(solicitor_dr.solicitor_name)
    end
    within ".accepted-defence-request" do
      expect(page).to_not have_content(other_solicitor_dr.solicitor_name)
    end
  end

  context "when the dashboard refreshes to update defence request information" do
    specify "they can still only see requests the they have accepted", js: true, short_dashboard_refresh: true do
      visit defence_requests_path

      within ".accepted-defence-request" do
        expect(page).to have_content(solicitor_dr.detainee_name)
        expect(page).to_not have_content(solicitor_dr_not_accepted.detainee_name)
      end
      expect(page).to_not have_selector(".created-defence-request")
      expect(page).to_not have_selector(".open-defence-request")

      wait_for_dashboard_refresh

      within ".accepted-defence-request" do
        expect(page).to have_content(solicitor_dr.detainee_name)
        expect(page).to_not have_content(solicitor_dr_not_accepted.detainee_name)
      end

      expect(page).to_not have_selector(".created-defence-request")
      expect(page).to_not have_selector(".open-defence-request")
    end
  end
end
