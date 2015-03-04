require "rails_helper"

RSpec.feature "Custody Suite Officers managing defence requests" do

  before :each do
    create_role_and_login("cso")
  end

  context "creating a new request" do
    specify "can not see a DSCC field on the defence request form" do
      visit root_path
      click_link "New Defence Request"

      expect(page).not_to have_field("DSCC Number")
    end

    specify "can not see the solicitor time of arrival field on the defence request form" do
      visit root_path
      click_link "New Defence Request"

      expect(page).not_to have_field("Expected Solicitor Time of Arrival")
    end

    specify "can fill in form manually with all relevant details for own solicitor", js: true do
      visit root_path
      click_link "New Defence Request"
      expect(page).to have_content ("New Defence Request")

      within ".new_defence_request" do
        choose "Own"
        within ".solicitor-details" do
          fill_in "Full Name", with: "Bob Smith"
          fill_in "Name of firm", with: "Acme Solicitors"
          fill_in "Telephone number", with: "0207 284 0000"
        end

        within ".case-details" do
          fill_in "Custody number", with: "#CUST-01234"
          fill_in "Allegations", with: "BadMurder"
          fill_in "defence_request_time_of_arrival_day", with: "01"
          fill_in "defence_request_time_of_arrival_month", with: "01"
          fill_in "defence_request_time_of_arrival_year", with: "2001"
          fill_in "defence_request_time_of_arrival_hour", with: "01"
          fill_in "defence_request_time_of_arrival_min", with: "01"
        end

        within ".detainee" do
          fill_in "Full Name", with: "Mannie Badder"
          choose "Male"
          fill_in "Age", with: "39"
          fill_in "defence_request_date_of_birth_year", with: "1976"
          fill_in "defence_request_date_of_birth_month", with: "01"
          fill_in "defence_request_date_of_birth_day", with: "01"
          choose "No"
        end
        fill_in "Comments", with: "This is a very bad man. Send him down..."
        click_button "Create Defence Request"
      end
      an_audit_should_exist_for_the_defence_request_creation
      expect(page).to have_content "Bob Smith"
      expect(page).to have_content "Defence Request successfully created"
    end

    specify "can choose own solicitor and pick a solicitor using a from search box from the form", js: true do
      stub_solicitor_search_for_bob_smith
      visit root_path
      click_link "New Defence Request"
      choose "Own"
      fill_in "q", with: "Bob Smith"

      find(".solicitor-search", match: :first).click
      expect(page).to have_content "Bobson Smith"
      expect(page).to have_content "Bobby Bob Smithson"

      click_link "Bobson Smith"
      expect(page).to_not have_content "Bobby Bob Smithson"
      within ".solicitor-details" do
        expect(page).to have_field "Full Name", with: "Bobson Smith"
        expect(page).to have_field "Name of firm", with: "Kreiger LLC"
        expect(page).to have_field "Telephone number", with: "248.412.8095"
      end
    end

    specify "can perform multiple own solicitor searches", js: true do
      stub_solicitor_search_for_bob_smith
      stub_solicitor_search_for_barry_jones

      visit root_path
      click_link "New Defence Request"
      choose "Own"
      fill_in "q", with: "Bob Smith"
      find(".solicitor-search", match: :first).click

      expect(page).to have_content "Bobson Smith"

      fill_in "q", with: "Barry Jones"
      click_button "Search"

      find_link("Barry Jones").visible?
      expect(page).to_not have_content "Bobson Smith"
    end

    specify "are shown a message when no results are found for their search", js: true do
      stub_solicitor_search_for_mystery_man

      visit root_path
      click_link "New Defence Request"
      choose "Own"
      fill_in "q", with: "Mystery Man"
      find(".solicitor-search", match: :first).click

      expect(page).to have_content "No results found"
    end

    specify "can clear the solicitor search results with a close button", js: true do
      stub_solicitor_search_for_bob_smith
      visit root_path
      click_link "New Defence Request"
      choose "Own"
      fill_in "q", with: "Bob Smith"
      find(".solicitor-search", match: :first).click
      expect(page).to have_content "Bobson Smith"

      within(".solicitor-results-list") do
        click_link("Close")
      end
      expect(page).not_to have_content "Bobson Smith"
    end

    specify "can clear the solicitor search results by pressing the ESC key", js: true do
      stub_solicitor_search_for_bob_smith
      visit root_path
      click_link "New Defence Request"
      choose "Own"
      fill_in "q", with: "Bob Smith"

      find(".solicitor-search", match: :first).click
      expect(page).to have_content "Bobson Smith"

      page.execute_script("$(\"body\").trigger($.Event(\"keydown\", { keyCode: 27 }))")
      expect(page).not_to have_content "Bobson Smith"
    end

    specify "has the solicitor search results cleared when toggling between \"duty\" or \"own\" solicitor", js: true do
      stub_solicitor_search_for_bob_smith

      visit root_path
      click_link "New Defence Request"
      choose "Own"
      fill_in "q", with: "Bob Smith"
      find(".solicitor-search", match: :first).click
      click_link "Bobson Smith"
      choose "Duty"

      expect(page).to_not have_content "Bobson Smith"

      choose "Own"
      expect(page).to have_field "q", with: ""
    end
  end

  context "with requests they are assigned to" do
    let!(:dr_created) { create(:defence_request) }

    specify "can close the request from the dashboard" do
      visit root_path
      within "#defence_request_#{dr_created.id}" do
        click_link "Close"
      end
      expect(page).to have_content("Close the Defence Request")
      click_button "Close"
      expect(page).to have_content("Feedback: can't be blank")
      expect(page).to have_content("Close the Defence Request")

      fill_in "Feedback", with: "I just cant take it any more..."
      click_button "Close"
      expect(page).to have_content("Defence Request successfully closed")
      expect(page).to have_content("Custody Suite Officer Dashboard")
      dr_created.reload
      expect(dr_created.state).to eq "closed"
    end

    specify "can close the request from the edit page" do
      visit root_path
      within "#defence_request_#{dr_created.id}" do
        click_link "Edit"
      end
      click_link "Close"
      expect(page).to have_content("Close the Defence Request")
      click_button "Close"
      expect(page).to have_content("Feedback: can't be blank")
      expect(page).to have_content("Close the Defence Request")

      fill_in "Feedback", with: "I just cant take it any more..."
      click_button "Close"
      expect(page).to have_content("Defence Request successfully closed")
      expect(page).to have_content("Custody Suite Officer Dashboard")
      dr_created.reload
      expect(dr_created.state).to eq "closed"
    end

    context "with requests that have not been opened yet" do
      specify "can edit all relevant details of the request" do
        visit root_path
        within "#defence_request_#{dr_created.id}" do
          click_link "Edit"
        end
        expect(page).to have_content ("Edit Defence Request")

        within ".edit_defence_request" do
          within ".solicitor-details" do
            fill_in "Full Name", with: "Dave Smith"
            fill_in "Name of firm", with: "Broken Solicitors"
            fill_in "Telephone number", with: "0207 284 9999"
            expect(page).to_not have_selector("defence_request_solicitor_time_of_arrival_1i")
          end

          within ".case-details" do
            fill_in "Custody number", with: "#CUST-9876"
            fill_in "Allegations", with: "BadMurder"
            fill_in "defence_request_interview_start_time_day", with: "01"
            fill_in "defence_request_interview_start_time_month", with: "01"
            fill_in "defence_request_interview_start_time_year", with: "2001"
            fill_in "defence_request_interview_start_time_hour", with: "01"
            fill_in "defence_request_interview_start_time_min", with: "01"
          end

          within ".detainee" do
            fill_in "Full Name", with: "Mannie Badder"
            choose "Male"
            fill_in "Age", with: "39"
            fill_in "defence_request_date_of_birth_year", with: "1976"
            fill_in "defence_request_date_of_birth_month", with: "01"
            fill_in "defence_request_date_of_birth_day", with: "01"
            choose "No"
          end

          within ".detainee" do
            fill_in "Full Name", with: "Annie Nother"
            choose "Female"
            fill_in "Age", with: "28"
            fill_in "defence_request_date_of_birth_year", with: "1986"
            fill_in "defence_request_date_of_birth_month", with: "12"
            fill_in "defence_request_date_of_birth_day", with: "12"
            choose "Yes"
          end
          fill_in "Comments", with: "I fought the law..."
          click_button "Update Defence Request"
        end

        within "#defence_request_#{dr_created.id}" do
          expect(page).to have_content("Dave Smith")
          expect(page).to have_content("02072849999")
          expect(page).to have_content("#CUST-9876")
          expect(page).to have_content("BadMurder")
          expect(page).to have_content("Annie")
          expect(page).to have_content("Nother")
        end
      end
    end

    context "with accepted requests" do
      let!(:accepted_dr) { create(:defence_request, :accepted) }

      specify "can not edit the expected arrival time from request show page"do
        visit defence_requests_path
        within ".accepted-defence-request" do
          click_link("Show")
        end

        expect(page).to_not have_selector(".time-of-arrival")
      end
    end
  end
end

def an_audit_should_exist_for_the_defence_request_creation
  expect(DefenceRequest.first.audits.length).to eq 1
  audit = DefenceRequest.first.audits.first

  expect(audit.auditable_type).to eq "DefenceRequest"
  expect(audit.action).to eq "create"
end

def stub_solicitor_search_for_bob_smith
  body = File.open "spec/fixtures/bob_smith_solicitor_search.json"
  stub_request(:post, "http://solicitor-search.herokuapp.com/search/?q=Bob%20Smith").
    to_return(body: body, status: 200)
end

def stub_solicitor_search_for_barry_jones
  body = File.open "spec/fixtures/barry_jones_solicitor_search.json"
  stub_request(:post, "http://solicitor-search.herokuapp.com/search/?q=Barry%20Jones").
    to_return(body: body, status: 200)
end

def stub_solicitor_search_for_mystery_man
  body = {solicitors: [], firms: []}.to_json
  stub_request(:post, "http://solicitor-search.herokuapp.com/search/?q=Mystery%20Man").
    to_return(body: body, status: 200)
end
