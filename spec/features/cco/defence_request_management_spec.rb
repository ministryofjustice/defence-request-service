require "rails_helper"

RSpec.feature "Call Center Operatives managing defence requests" do
  let(:cco_user) { FactoryGirl.create(:cco_user) }

  before :each do
    login_as_user(cco_user.email)
  end

  context "with any request" do
    let!(:accepted_dr) { create(:defence_request, :accepted) }

    specify "can see the show page of the request" do
      visit defence_requests_path
      within ".accepted-defence-request" do
        click_link "Show"
      end

      expect(page).to have_content("Case Details")
      expect(page).to have_content(accepted_dr.solicitor_name)
      expect(page).to have_link("Dashboard")
    end

    specify "can not edit expected time of arrival from the request show page" do
      visit defence_requests_path
      within ".accepted-defence-request" do
        click_link("Show")
      end

      expect(page).to_not have_selector(".time-of-arrival")
    end

    specify "can close the request from the dashboard" do
      visit root_path
      within "#defence_request_#{accepted_dr.id}" do
        click_link "Close"
      end
      expect(page).to have_content("Close the Defence Request")
      click_button "Close"
      expect(page).to have_content("Feedback: can't be blank")
      expect(page).to have_content("Close the Defence Request")

      fill_in "Feedback", with: "I just cant take it any more..."
      click_button "Close"
      expect(page).to have_content("Defence Request successfully closed")
      expect(page).to have_content("Call Center Operative Dashboard")
      accepted_dr.reload
      expect(accepted_dr.state).to eq "closed"
    end
  end

  context "with requests they are assigned to" do

    context "that have not yet been opened" do
      let!(:unopened_dr) { create(:defence_request, :queued) }

      specify "cannot edit the request" do
        visit root_path
        within "#defence_request_#{unopened_dr.id}" do
          expect(page).not_to have_link("Edit")
        end
      end

      specify "can open the request" do
        visit root_path
        within "#defence_request_#{unopened_dr.id}" do
          click_button "Open"
        end
        expect(page).to have_content "Defence Request successfully opened"
      end

      specify "are shown a message if the request cannot be opened for some reason" do
        visit root_path
        dr_can_not_be_opened_for_some_reason unopened_dr
        within "#defence_request_#{unopened_dr.id}" do
          click_button "Open"
        end
        expect(page).to have_content "Defence Request was not opened"
      end

      specify "cannot mark the request as accepted" do
        visit root_path
        within ".queued-defence-request" do
          expect(page).to_not have_button "Accepted"
        end
        within "#defence_request_#{unopened_dr.id}" do
          expect(page).to_not have_button "Accepted"
        end
      end
    end

    context "that have been opened by this cco" do
      let!(:opened_dr) { create(:defence_request, :opened, :with_solicitor, cco: cco_user) }

      specify "can edit the solicitors details on the request" do
        visit root_path
        within "#defence_request_#{opened_dr.id}" do
          click_link "Edit"
        end

        within ".solicitor-details" do
          fill_in "Full Name", with: "Henry Billy Bob"
          fill_in "Name of firm", with: "Cheap Skate Law"
          fill_in "Telephone number", with: "00112233445566"
        end

        click_button "Update Defence Request"
        expect(current_path).to eq(defence_requests_path)

        within "#defence_request_#{opened_dr.id}" do
          expect(page).to have_content "Henry Billy Bob"
          expect(page).to have_content "00112233445566"
        end
      end

      specify "can add/edit the DSCC number on the request" do
        visit root_path
        within "#defence_request_#{opened_dr.id}" do
          click_link "Edit"
        end
        fill_in "DSCC number", with: "NUMBERWANG"
        click_button "Update Defence Request"
        expect(page).to have_content "Defence Request successfully updated"
        within "#defence_request_#{opened_dr.id}" do
          click_link "Edit"
        end
        expect(page).to have_field "DSCC number", with: "NUMBERWANG"
        fill_in "DSCC number", with: "T-1000"
        click_button "Update Defence Request"
        expect(page).to have_content "Defence Request successfully updated"
      end

      specify "can mark the request as accepted from the request's edit page whilst adding a dscc number" do
        visit root_path

        within "#defence_request_#{opened_dr.id}" do
          click_link "Edit"
        end
        fill_in "DSCC number", with: "123456"

        click_button "Update and Accept"
        within ".accepted-defence-request" do
          expect(page).to have_content(opened_dr.solicitor_name)
        end
      end

      specify "can not choose \"Update and Accept\" from the request's edit page without adding a dscc number" do
        visit root_path

        within "#defence_request_#{opened_dr.id}" do
          click_link "Edit"
        end

        click_button "Update and Accept"
        expect(page).to have_content("A Valid DSCC number is required to update and accept a Defence Request")
      end

      context "that have a dscc number" do
        specify "can accept the request from the dashboard" do
          opened_dr.update(dscc_number: "012345")
          visit root_path
          within "#defence_request_#{opened_dr.id}" do
            click_button "Accepted"
          end
          within ".accepted-defence-request" do
            expect(page).to have_content(opened_dr.solicitor_name)
          end
          expect(page).to have_content("Defence Request was marked as accepted")
        end

        specify "are shown an error if the request cannot be accepted" do
          opened_dr.update(dscc_number: "012345")
          visit root_path
          dr_can_not_be_accepted_for_some_reason opened_dr
          within "#defence_request_#{opened_dr.id}" do
            click_button "Accepted"
          end
          expect(page).to have_content("Defence Request was not marked as accepted")
        end
      end

      context "that have the \"duty\" solicitor type" do
        let!(:duty_solicitor_dr) { create(:defence_request, :duty_solicitor, :opened, cco: cco_user) }

        specify "can not mark the request as accepted from the dashboard without solicitor detials" do
          visit root_path
          within "#defence_request_#{duty_solicitor_dr.id}" do
            expect(page).to_not have_button "Accepted"
          end
        end

        specify "can only mark the request as accepted from the edit page with solicitor details and dscc number" do
          visit root_path

          within "#defence_request_#{duty_solicitor_dr.id}" do
            click_link "Edit"
          end
          click_button "Update and Accept"
          expect(page).to have_content("Valid solicitor details are required to update and accept a Defence Request")

          within ".solicitor-details" do
            fill_in "Full Name", with: "Dodgy Dave"
          end
          click_button "Update and Accept"
          expect(page).to have_content("Valid solicitor details are required to update and accept a Defence Request")
          within ".solicitor-details" do
            fill_in "Full Name", with: "Dodgy Dave"
            fill_in "Name of firm", with: "Innocent your honour"
          end
          click_button "Update and Accept"

          expect(page).to have_content("A Valid DSCC number is required to update and accept a Defence Request")
          within ".solicitor-details" do
            fill_in "Full Name", with: "Dodgy Dave"
            fill_in "Name of firm", with: "Innocent your honour"
          end
          fill_in "DSCC number", with: "123456"
          click_button "Update and Accept"
          expect(page).to have_content("Defence Request successfully updated and marked as accepted")
        end
      end
    end
  end


  context "that have been marked as accepted" do
    let!(:accepted_dr) { create(:defence_request, :accepted, :with_solicitor, cco: cco_user) }

    specify "can edit the expected time of arrival on the request" do
      visit root_path

      within ".accepted-defence-request" do
        expect(page).to have_content(accepted_dr.solicitor_name)
      end

      within ".accepted-defence-request" do
        click_link "Edit"
      end

      within ".solicitor-details" do
        fill_in "defence_request_solicitor_time_of_arrival_day", with: "01"
        fill_in "defence_request_solicitor_time_of_arrival_month", with: "01"
        fill_in "defence_request_solicitor_time_of_arrival_year", with: "2001"
        fill_in "defence_request_solicitor_time_of_arrival_hour", with: "01"
        fill_in "defence_request_solicitor_time_of_arrival_min", with: "01"
      end
      click_button "Update Defence Request"
      expect(page).to have_content "Defence Request successfully updated"
      within ".accepted-defence-request" do
        click_link "Show"
      end
      expect(page).to have_content("1 January 2001 - 01:01")
    end
  end
end

def dr_can_not_be_opened_for_some_reason defence_request
  expect(DefenceRequest).to receive(:find).with(defence_request.id.to_s) { defence_request }
  expect(defence_request).to receive(:open) { false }
end

def dr_can_not_be_accepted_for_some_reason defence_request
  expect(DefenceRequest).to receive(:find).with(defence_request.id.to_s) { defence_request }
  expect(defence_request).to receive(:accept) { false }
end

