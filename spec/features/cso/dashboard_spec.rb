require "rails_helper"

RSpec.feature "Custody Suite Officers viewing their dashboard" do
  include ActiveJobHelper
  include DashboardHelper

  let!(:dr_draft) { create(:defence_request, :draft) }
  let!(:dr_ack1) { create(:defence_request, :acknowledged) }
  let!(:dr_ack2) { create(:defence_request, :acknowledged) }
  let!(:dr_accepted) { create(:defence_request, :accepted) }

  before :each do
    create_role_and_login("cso")
  end

  specify "can see all active defence requests in chronological order" do
    visit defence_requests_path

    within "#defence_request_#{dr_draft.id}" do
      expect(page).to have_content(dr_draft.solicitor_name)
    end

    within "#defence_request_#{dr_draft.id}" do
      expect(element_order_correct?("defence_request_#{dr_ack1.id}", "defence_request_#{dr_ack2.id}")).to eq true
    end
  end

  specify "can see the dashboard with refreshed data after a period", js: true, short_dashboard_refresh: true do
    visit defence_requests_path

    within "#defence_request_#{dr_draft.id}" do
      expect(page).to have_content(dr_draft.solicitor_name)
    end

    within "#defence_request_#{dr_ack1.id}" do
      expect(page).to have_content(dr_ack1.solicitor_name)
    end

    dr_draft.update(solicitor_name: "New Solicitor")
    dr_ack1.update(solicitor_name: "New Solicitor2")

    wait_for_dashboard_refresh

    within "#defence_request_#{dr_draft.id}" do
      expect(page).to have_content("New Solicitor")
    end

    within "#defence_request_#{dr_ack1.id}" do
      expect(page).to have_content("New Solicitor2")
    end
  end

  specify "can send a draft case for processing" do
    visit defence_requests_path

    within ".draft-defence-request" do
      click_button "Send for Processing"
    end

    expect(page).to have_content("Defence Request successfully sent for processing")
    within ".queued-defence-request" do
      expect(page).to have_content(dr_draft.solicitor_name)
    end
  end

  specify "are shown an error message if a case cannot be sent for processing" do
    visit defence_requests_path

    dr_can_not_be_sent_for_processing_for_some_reason dr_draft
    within ".draft-defence-request" do
      click_button "Send for Processing"
    end

    expect(page).to have_content("Defence Request was not sent for processing")
    expect(page).to_not have_selector(".queued-defence-request")
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

  def check_abort_request defence_request
    visit defence_requests_path
    request_id = "#defence_request_#{defence_request.id}"
    within request_id do
      click_link 'Abort'
    end
    reason = "Reason for abort"
    fill_in "Reason aborted", with: reason
    click_button 'Abort'

    expect(page).to have_content('Defence Request successfully aborted')
    expect(page).to_not have_selector(request_id)

    defence_request = defence_request.reload
    expect(defence_request.state).to eq('aborted')
    expect(defence_request.reason_aborted).to eq(reason)
  end

  specify 'can abort queued defence request', js: true do
    dr_draft.queue
    dr_draft.save
    check_abort_request dr_draft
  end

  specify 'can abort acknowledged defence request', js: true do
    check_abort_request dr_ack1
  end

  specify 'can abort accepted defence request', js: true do
    check_abort_request dr_accepted
  end
end

def element_order_correct?(first_element, second_element)
  !!(/#{first_element}.*#{second_element}/m =~ page.body)
end

def dr_can_not_be_sent_for_processing_for_some_reason defence_request
  expect(DefenceRequest).to receive(:find).with(defence_request.id.to_s) { defence_request }
  expect(defence_request).to receive(:queue) { false }
end
