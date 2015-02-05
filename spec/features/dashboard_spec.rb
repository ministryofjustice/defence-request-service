require 'rails_helper'

RSpec.feature 'Defence request dashboard' do

  context 'as a cso' do
    before :each do
      create_cso_and_login
    end

    let!(:dr_1) { create(:defence_request) }
    let!(:dr_2) { create(:defence_request) }

    scenario 'i am redirected to my dashboard at login' do
      expect(page).to have_content('CSO Dashboard')
    end

    scenario 'i can see all active DR`s in chronological order' do
      visit defence_requests_path

      within ".defence_requests" do
        expect(element_order_correct?("defence_request_#{dr_1.id}","defence_request_#{dr_2.id}")).to eq true
      end
    end

    scenario 'i can see the dashboard with refreshed data after a period', js: true do
      Settings.dsds.dashboard_refresh_seconds = 200
      visit defence_requests_path

      within "#defence_request_#{dr_1.id}" do
        expect(page).to have_content(dr_1.solicitor_name)
      end

      dr_1.update(solicitor_name: 'New Solicitor')

      sleep(Settings.dsds.dashboard_refresh_seconds/1000)
      within "#defence_request_#{dr_1.id}" do
        expect(page).to have_content('New Solicitor')
      end
    end

    scenario 'Closing a case' do
      visit defence_requests_path

      expect(page).to have_content dr_1.solicitor_name

      within "#defence_request_#{dr_1.id}" do
        click_button 'Close'
      end

      expect(page).to have_content "Defence Request successfully closed"
      expect(page).to_not have_content dr_1.solicitor_name
    end

  end
  def element_order_correct?(first_element,second_element)
    !!(/#{first_element}.*#{second_element}/m =~ page.body)
  end
end
