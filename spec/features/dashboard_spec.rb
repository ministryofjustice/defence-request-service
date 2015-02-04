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

    scenario 'i can see all active DR`s' do
      visit defence_requests_path

      within "#dr_#{dr_1.id}" do
        expect(page).to have_content(dr_1.solicitor_name)
      end

      within "#dr_#{dr_2.id}" do
        expect(page).to have_content(dr_2.solicitor_name)
      end
    end

    scenario 'i can see the dashboard with refreshed data after a period', js: true do
      visit defence_requests_path

      within "#dr_#{dr_1.id}" do
        expect(page).to have_content(dr_1.solicitor_name)
      end

      dr_1.update(solicitor_name: 'New Solicitor')
      sleep(3)
      within "#dr_#{dr_1.id}" do
        expect(page).to have_content('New Solicitor')
      end
    end

  end

end
