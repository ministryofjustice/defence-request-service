require "rails_helper"

RSpec.feature "Custody Center Operatives viewing their dashboard" do
    include ActiveJobHelper

    let!(:dr_created) { create(:defence_request, :created) }
    let!(:dr_open) { create(:defence_request, :opened) }
    let!(:dr_accepted) { create(:defence_request, :accepted) }
    let(:cco_user2){ create :cco_user }

    before :each do
      create_role_and_login("cco")
    end

    specify "can see tables of \"created\" and \"open\" defence requests" do
      visit defence_requests_path

      within ".created-defence-request" do
        expect(page).to have_content(dr_created.solicitor_name)
      end

      within ".open-defence-request" do
        expect(page).to have_content(dr_open.solicitor_name)
      end
    end

    specify "can see the dashboard with refreshed data after a period", js: true do
      visit defence_requests_path

      within "#defence_request_#{dr_created.id}" do
        expect(page).to have_content(dr_created.solicitor_name)
      end

      within "#defence_request_#{dr_open.id}" do
        expect(page).to have_content(dr_open.solicitor_name)
      end

      dr_created.update(solicitor_name: "New Solicitor")
      dr_open.update(solicitor_name: "New Solicitor2")
      #Wait for dashboard refresh + 1
      sleep(4)
      wait_for_ajax

      within "#defence_request_#{dr_created.id}" do
        expect(page).to have_content("New Solicitor")
      end
      within "#defence_request_#{dr_open.id}" do
        expect(page).to have_content("New Solicitor2")
      end

    end

    specify "can resend case details of an defence request to the assigned solicitor", js: true do
      visit defence_requests_path

      within ".accepted-defence-request" do
        click_button "Resend details"
      end

      page.execute_script "window.confirm"

      expect(page).to have_content("Details successfully sent")
      an_email_has_been_sent
    end

end
