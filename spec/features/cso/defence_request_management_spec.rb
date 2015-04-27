require "rails_helper"

RSpec.feature "Custody Suite Officers managing defence requests" do
  context "creating a new request" do
    context "duty solicitor" do
      specify "can not edit name Solicitor Name, Solicitor Firm or Phone Number" do
        create :defence_request, :duty_solicitor
        cso_user = create :cso_user

        login_with cso_user
        click_link "Edit"

        expect(page).to have_css "#defence_request_solicitor_name[disabled]"
        expect(page).to have_css "#defence_request_solicitor_firm[disabled]"
        expect(page).to have_css "#defence_request_phone_number[disabled]"
      end

      context "own solicitor" do
        specify "can fill in form manually with all relevant details for own solicitor", js: true do
          cso_user = create :cso_user

          login_with cso_user
          click_link "New Defence Request"
          choose "Own"
          fill_in_defence_request_form
          click_button "Create Defence Request"

          an_audit_should_exist_for_the_defence_request_creation
          expect(page).to have_content "Defence Request successfully created"
        end

        specify "can not see a DSCC field on the defence request form" do
          cso_user = create :cso_user

          login_with cso_user
          click_link "New Defence Request"

          expect(page).not_to have_field "DSCC Number"
        end

        specify "can not see the solicitor time of arrival field on the defence request form" do
          cso_user = create :cso_user

          login_with cso_user
          click_link "New Defence Request"

          expect(page).not_to have_field "Expected Solicitor Time of Arrival"
        end

        specify "are shown some errors if the request cannot be created due to invalid fields" do
          cso_user = create :cso_user

          login_with cso_user
          click_link "New Defence Request"
          within ".detainee" do
            fill_in "Full Name", with: ""
          end
          click_button "Create Defence Request"

          expect(page).
            to have_content "You need to fix the errors on this page before continuing"
          expect(page).to have_content "Detainee name: can't be blank"
        end

        specify "appropriate_adult toggles appropriate_adult_reason", js: true do
          cso_user = create :cso_user

          login_with cso_user
          click_link "New Defence Request"
          choose "Own"
          within ".detainee" do
            choose "defence_request_appropriate_adult_true"
          end

          expect(page).
            to_not have_css "#defence_request_appropriate_adult_reason[disabled]"
        end

        xspecify "can choose own solicitor and pick a solicitor using a from search box from the form", js: true do
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

        xspecify "a solicitor with a apostrophe renders correctly", js: true do
          stub_solicitor_search_for_dave_oreilly

          visit root_path
          click_link "New Defence Request"
          choose "Own"
          fill_in "q", with: "Dave O'Reilly"

          find(".solicitor-search", match: :first).click

          expect(page).to have_content "Dave O'Reilly"

          click_link "Dave O'Reilly"

          within ".solicitor-details" do
            expect(page).to have_field "Full Name", with: "Dave O'Reilly"
          end
        end

        xspecify "can perform multiple own solicitor searches", js: true do
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
      end

      xspecify "are shown a message when no results are found for their search", js: true do
        stub_solicitor_search_for_mystery_man

        visit root_path
        click_link "New Defence Request"
        choose "Own"
        fill_in "q", with: "Mystery Man"
        find(".solicitor-search", match: :first).click

        expect(page).to have_content "No results found"
      end

      xspecify "can clear the solicitor search results with a close button", js: true do
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
    end

    xspecify "can clear the solicitor search results by pressing the ESC key", js: true do
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

    xspecify "has the solicitor search results cleared when toggling between \"duty\" or \"own\" solicitor", js: true do
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
    context "own solicitor" do
      context "with requests that have not been queued yet" do
        specify "can edit all relevant details of the request", js: true do
          cso_user = create :cso_user
          create :defence_request

          login_with cso_user
          click_link "Edit"
          fill_in_defence_request_form edit: true
          click_button "Update Defence Request"

          expect(page).to have_content "Defence Request successfully updated"
        end

        specify "are shown some errors if the request cannot be updated due to invalid fields" do
          cso_user = create :cso_user
          create :defence_request

          login_with cso_user
          click_link "Edit"
          within ".detainee" do
            fill_in "Age", with: "MOOOSE ON THE LOOOSE!?!"
          end
          click_button "Update Defence Request"

          expect(page).to have_content "You need to fix the errors on this page before continuing"
          expect(page).to have_content "Detainee age: is not a number"
        end
      end

      context "with requests that are no longer in draft state" do
        specify "can abort the request" do
          cso_user = create :cso_user
          create :defence_request, :queued

          login_with cso_user
          abort_defence_request

          expect(page).to have_content "Defence Request successfully aborted"
        end

        specify "are shown an error message if the defence request could not be aborted" do
          cso_user = create :cso_user
          create :defence_request, :queued

          login_with cso_user
          abort_defence_request reason: ""

          expect(page).to have_content "Reason aborted: can't be blank"
          expect(page).to have_content "Abort the Defence Request"
        end
      end

      context "with accepted requests" do
        specify "can not edit the expected arrival time from request show page" do
          cso_user = create :cso_user
          create :defence_request, :accepted

          login_with cso_user
          click_link "Show"

          expect(page).to_not have_selector ".time-of-arrival"
        end
      end
    end
  end

  context "viewing a defence request" do
    specify "shows all required fields" do
      cso_user = create :cso_user
      defence_request = create(
        :defence_request,
        :accepted,
        :appropriate_adult,
        :interview_start_time,
        :solicitor_time_of_arrival,
        :unfit_for_interview,
        :with_address,
        :with_circumstance_of_arrest,
        :with_custody_address,
        :with_dscc_number,
        :with_interpreter_required,
        :with_investigating_officer,
        :with_time_of_arrest,
        :with_time_of_detention_authorised,
      )

      login_with cso_user
      click_link "Show"

      expect(page).to have_content defence_request.dscc_number
    end
  end
end