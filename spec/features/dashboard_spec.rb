require 'rails_helper'

RSpec.feature 'Defence request dashboard' do

  context 'as a cso' do
    before :each do
      create_role_and_login('cso')
    end

    let!(:dr_created) { create(:defence_request, :created) }
    let!(:dr_open1) { create(:defence_request, :opened) }
    let!(:dr_open2) { create(:defence_request, :opened) }
    let!(:dr_accepted) { create(:defence_request, :accepted) }

    scenario 'i am redirected to my dashboard at login' do
      expect(page).to have_content('Custody Suite Officer Dashboard')
    end

    scenario 'i can see all active DR`s in chronological order' do
      visit defence_requests_path

      within "#defence_request_#{dr_created.id}" do
        expect(page).to have_content(dr_created.solicitor_name)
      end

      within "#defence_request_#{dr_created.id}" do
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

    scenario 'any update to the "created" DR by the cso results in it NOT moving to "created" after the refresh' do
      visit defence_requests_path

      within "#defence_request_#{dr_created.id}" do
        expect(page).to have_content(dr_created.solicitor_name)
      end

      within "#defence_request_#{dr_created.id}" do
        click_link 'Edit'
      end

      within '#solicitor-details' do
        fill_in 'Full Name', with: 'Bob Smith'
      end

      click_button 'Update Defence Request'

      within ".created_defence_request#defence_request_#{dr_created.id}" do
        expect(page).to have_content('Bob Smith')
      end

      expect(page).to_not have_selector(".open_defence_request#defence_request_#{dr_created.id}")
    end

    scenario 'resending case details', js: true do
      visit defence_requests_path

      within ".accepted_defence_request" do
        click_button 'Resend details'
      end

      page.execute_script "window.confirm"

      expect(page).to have_content("Details successfully sent")
      an_email_has_been_sent
    end
  end

  context 'as a cco' do
    before :each do
      create_role_and_login('cco')
    end

    let!(:dr_created) { create(:defence_request, :created) }
    let!(:dr_open) { create(:defence_request, :opened) }
    let!(:dr_accepted) { create(:defence_request, :accepted) }
    let(:cco_user2){ create :cco_user }

    scenario 'i am redirected to my dashboard at login' do
      expect(page).to have_content('Call Center Operative Dashboard')
      expect(page).to_not have_content('Custody Suite Officer Dashboard')
    end

    scenario 'i see a tables of "created" and "open" DR`s`' do
      visit defence_requests_path

      within ".created_defence_request" do
        expect(page).to have_content(dr_created.solicitor_name)
      end
      within ".open_defence_request" do
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

    scenario 'any update to the "created" DR by the cco results in it moving to "created" after the refresh' do
      visit defence_requests_path

      within ".created_defence_request#defence_request_#{dr_created.id}" do
        expect(page).to have_content(dr_created.solicitor_name)
      end

      within ".created_defence_request#defence_request_#{dr_created.id}" do
        click_button 'Open'
      end

      expect(page).to_not have_selector(".created_defence_requests#defence_request_#{dr_created.id}")
    end

    scenario 'resending case details', js: true do
      visit defence_requests_path

      within ".accepted_defence_request" do
        click_button 'Resend details'
      end

      page.execute_script "window.confirm"

      expect(page).to have_content("Details successfully sent")
      an_email_has_been_sent
    end

    scenario 'an unassigned cco cannot edit a dr' do
      cco_user = User.find_by(email: 'cco@example.com')
      visit defence_requests_path
      within ".created_defence_request#defence_request_#{dr_created.id}" do
        click_button 'Open'
      end

      within ".open_defence_request#defence_request_#{dr_created.id}" do
        expect(page).to have_link('Edit')
      end
      dr_created.reload
      expect(dr_created.cco).to eq cco_user

      sign_out

      login_as_user(cco_user2.email)

      within ".open_defence_request#defence_request_#{dr_created.id}" do
        expect(page).to_not have_link('Edit')
      end
    end
  end

  context 'as a solicitor' do
    let!(:solicitor_dr) { create(:defence_request, :accepted) }
    let!(:other_solicitor_dr) { create(:defence_request, :accepted) }
    let!(:other_solicitor) { create(:solicitor_user) }
    let!(:solicitor_dr_not_accepted) { create(:defence_request, :opened, dscc_number: '98765', solicitor: solicitor_dr.solicitor) }
    let!(:created_dr) { create(:defence_request, :created, dscc_number: '98765', solicitor: solicitor_dr.solicitor) }

    before :each do
      login_as_user(solicitor_dr.solicitor.email)
    end

    scenario 'i am redirected to my dashboard at login' do
      expect(page).to have_content('Solicitor Dashboard')
      expect(page).to_not have_content('Custody Suite Officer Dashboard')
    end

    scenario 'i see only MY "accepted" DR`s`' do
      visit defence_requests_path
      within ".accepted_defence_request" do
        expect(page).to have_content(solicitor_dr.solicitor_name)
      end
      within ".accepted_defence_request" do
        expect(page).to_not have_content(other_solicitor_dr.solicitor_name)
      end
    end

    scenario 'after the refresh i can still see ONLY the correct data', js: true do
      visit defence_requests_path

      within ".accepted_defence_request" do
        expect(page).to have_content(solicitor_dr.detainee_name)
        expect(page).to_not have_content(solicitor_dr_not_accepted.detainee_name)
      end
      expect(page).to_not have_selector(".created_defence_request")
      expect(page).to_not have_selector(".open_defence_request")

      sleep(4)
      wait_for_ajax

      within ".accepted_defence_request" do
        expect(page).to have_content(solicitor_dr.detainee_name)
        expect(page).to_not have_content(solicitor_dr_not_accepted.detainee_name)
      end

      expect(page).to_not have_selector(".created_defence_request")
      expect(page).to_not have_selector(".open_defence_request")
    end
  end

  def element_order_correct?(first_element, second_element)
    !!(/#{first_element}.*#{second_element}/m =~ page.body)
  end
end
