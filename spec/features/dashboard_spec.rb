require 'rails_helper'

RSpec.feature 'Defence request dashboard' do

  context 'as a cso' do
    before :each do
      create_role_and_login('cso')
    end

    let!(:dr_created) { create(:defence_request, :created) }
    let!(:dr_open1) { create(:defence_request, :opened) }
    let!(:dr_open2) { create(:defence_request, :opened) }

    scenario 'i am redirected to my dashboard at login' do
      expect(page).to have_content('Custody Suite Officer Dashboard')
    end

    scenario 'i can see all active DR`s in chronological order' do
      visit defence_requests_path

      within ".new_defence_requests" do
        expect(page).to have_content(dr_created.solicitor_name)
      end

      within ".open_defence_requests" do
        expect(element_order_correct?("defence_request_#{dr_open1.id}", "defence_request_#{dr_open2.id}")).to eq true
      end
    end

    scenario 'i can see the dashboard with refreshed data after a period', js: true do
      Settings.dsds.dashboard_refresh_seconds = 3000
      visit defence_requests_path

      within "#defence_request_#{dr_created.id}" do
        expect(page).to have_content(dr_created.solicitor_name)
      end

      within "#defence_request_#{dr_open1.id}" do
        expect(page).to have_content(dr_open1.solicitor_name)
      end

      dr_created.update(solicitor_name: 'New Solicitor')
      dr_open1.update(solicitor_name: 'New Solicitor2')

      sleep(Settings.dsds.dashboard_refresh_seconds/1000)

      within "#defence_request_#{dr_created.id}" do
        expect(page).to have_content('New Solicitor')
      end
      within "#defence_request_#{dr_open1.id}" do
        expect(page).to have_content('New Solicitor2')
      end

    end

    scenario 'any update to the "created" DR by the cso results in it NOT moving to "new" after the refresh' do
      visit defence_requests_path

      within ".new_defence_requests" do
        expect(page).to have_content(dr_created.solicitor_name)
      end

      within ".new_defence_requests" do
        click_link 'Edit'
      end
      within '.details' do
        fill_in 'Solicitor name', with: 'Bob Smith'
      end

      click_button 'Update Defence Request'

      within ".new_defence_requests" do
        expect(page).to have_content('Bob Smith')
      end

      within ".open_defence_requests" do
        expect(page).to_not have_content('Bob Smith')
      end
    end
  end

  context 'as a cco' do
    before :each do
      create_role_and_login('cco')
    end

    let!(:dr_created) { create(:defence_request, :created) }
    let!(:dr_open) { create(:defence_request, :opened) }

    scenario 'i am redirected to my dashboard at login' do
      expect(page).to have_content('Call Center Operative Dashboard')
      expect(page).to_not have_content('Custody Suite Officer Dashboard')
    end

    scenario 'i see a tables of "new" and "open" DR`s`' do
      visit defence_requests_path

      within ".new_defence_requests" do
        expect(page).to have_content(dr_created.solicitor_name)
      end
      within ".open_defence_requests" do
        expect(page).to have_content(dr_open.solicitor_name)
      end

    end

    scenario 'i can see the dashboard with refreshed data after a period', js: true do
      visit defence_requests_path

      within "#defence_request_#{dr_created.id}" do
        expect(page).to have_content(dr_created.solicitor_name)
      end

      within "#defence_request_#{dr_open.id}" do
        expect(page).to have_content(dr_open.solicitor_name)
      end

      dr_created.update(solicitor_name: 'New Solicitor')
      dr_open.update(solicitor_name: 'New Solicitor2')
      #Wait for dashboard refresh + 1
      sleep(4)
      wait_for_ajax

      within "#defence_request_#{dr_created.id}" do
        expect(page).to have_content('New Solicitor')
      end
      within "#defence_request_#{dr_open.id}" do
        expect(page).to have_content('New Solicitor2')
      end

    end

    scenario 'any update to the "created" DR by the cco results in it moving to "new" after the refresh' do
      visit defence_requests_path

      within ".new_defence_requests" do
        expect(page).to have_content(dr_created.solicitor_name)
      end

      within ".new_defence_requests" do
        click_button 'Open'
      end

      within ".open_defence_requests" do
        expect(page).to have_content(dr_created.solicitor_name)
      end

    end
  end

  context 'as a solicitor' do
    before :each do
      create_role_and_login('solicitor')
      solicitor = User.find_by(email: 'solicitor@example.com')
      solicitor_dr.update(solicitor: solicitor)
      other_solicitor_dr.update(solicitor: other_solicitor)
    end

    scenario 'i am redirected to my dashboard at login' do
      expect(page).to have_content('Solicitor Dashboard')
      expect(page).to_not have_content('Custody Suite Officer Dashboard')
    end

    let!(:solicitor_dr) { create(:defence_request, :accepted) }
    let!(:other_solicitor_dr) { create(:defence_request, :accepted) }
    let!(:other_solicitor) { create(:solicitor_user) }

    scenario 'i see only MY "accepted" DR`s`' do
      visit defence_requests_path
      within ".accepted_defence_requests" do
        expect(page).to have_content(solicitor_dr.solicitor_name)
      end
      within ".accepted_defence_requests" do
        expect(page).to_not have_content(other_solicitor_dr.solicitor_name)
      end
    end
  end

  def element_order_correct?(first_element, second_element)
    !!(/#{first_element}.*#{second_element}/m =~ page.body)
  end
end
