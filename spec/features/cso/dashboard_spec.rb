require "rails_helper"

RSpec.feature "Custody Suite Officers viewing their dashboard" do
  include ActiveJobHelper
  let!(:dr_created) { create(:defence_request, :created) }
  let!(:dr_open1) { create(:defence_request, :opened) }
  let!(:dr_open2) { create(:defence_request, :opened) }
  let!(:dr_accepted) { create(:defence_request, :accepted) }

  before :each do
    create_role_and_login("cso")
  end

  specify "can see all active defence requests in chronological order" do
    visit defence_requests_path

    within "#defence_request_#{dr_created.id}" do
      expect(page).to have_content(dr_created.solicitor_name)
    end

    within "#defence_request_#{dr_created.id}" do
      expect(element_order_correct?("defence_request_#{dr_open1.id}", "defence_request_#{dr_open2.id}")).to eq true
    end
  end

  specify "can see the dashboard with refreshed data after a period", js: true do
    Settings.dsds.dashboard_refresh_seconds = 3000
    visit defence_requests_path

    within "#defence_request_#{dr_created.id}" do
      expect(page).to have_content(dr_created.solicitor_name)
    end

    within "#defence_request_#{dr_open1.id}" do
      expect(page).to have_content(dr_open1.solicitor_name)
    end

    dr_created.update(solicitor_name: "New Solicitor")
    dr_open1.update(solicitor_name: "New Solicitor2")

    sleep(Settings.dsds.dashboard_refresh_seconds/1000)

    within "#defence_request_#{dr_created.id}" do
      expect(page).to have_content("New Solicitor")
    end

    within "#defence_request_#{dr_open1.id}" do
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

def element_order_correct?(first_element, second_element)
  !!(/#{first_element}.*#{second_element}/m =~ page.body)
end
