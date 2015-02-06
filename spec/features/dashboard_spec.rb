require 'rails_helper'

RSpec.feature 'Defence request dashboard' do

  context 'as a cso' do
    before :each do
      create_role_and_login('cso')
    end

    let!(:dr_created){create(:defence_request, :created)}
    let!(:dr_open1){create(:defence_request, :open)}
    let!(:dr_open2){create(:defence_request, :open)}

    scenario 'i am redirected to my dashboard at login' do
      expect(page).to have_content('Custody Suite Officer Dashboard')
    end

    scenario 'i can see all active DR`s in chronological order' do
      visit defence_requests_path

      within ".new_defence_requests" do
        expect(page).to have_content(dr_created.solicitor_name)
      end

      within ".open_defence_requests" do
        expect(element_order_correct?("defence_request_#{dr_open1.id}","defence_request_#{dr_open2.id}")).to eq true
      end
    end

    scenario 'i can see the dashboard with refreshed data after a period', js: true do
      Settings.dsds.dashboard_refresh_seconds = 200
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

    context 'created case' do
      scenario 'can be closed' do
        visit defence_requests_path

        expect(page).to have_content dr_created.solicitor_name

        within "#defence_request_#{dr_created.id}" do
          click_button 'Close'
        end

        expect(page).to have_content "Defence Request successfully closed"
        expect(page).to_not have_content dr_created.solicitor_name
      end
    end

    context 'open case' do
      scenario 'can be closed' do
        visit defence_requests_path

        expect(page).to have_content dr_open1.solicitor_name

        within "#defence_request_#{dr_open1.id}" do
          click_button 'Close'
        end

        expect(page).to have_content "Defence Request successfully closed"
        expect(page).to_not have_content dr_open1.solicitor_name
      end
    end
  end

  context 'as a cco' do
    before :each do
      create_role_and_login('cco')
    end

    let!(:dr_created){create(:defence_request, :created)}
    let!(:dr_open){create(:defence_request, :open)}

    scenario 'i am redirected to my dashboard at login' do
      expect(page).to have_content('CCO Dashboard')
      expect(page).to_not have_content('CSO Dashboard')
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

  end

  def element_order_correct?(first_element,second_element)
    !!(/#{first_element}.*#{second_element}/m =~ page.body)
  end
end
