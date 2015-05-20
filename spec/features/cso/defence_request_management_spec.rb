require "rails_helper"

RSpec.feature "Custody Suite Officers managing defence requests" do
  context "creating a new request" do

    specify "can select \"not given\" for name, dob and address" do
      cso_user = create :cso_user

      login_with cso_user
      click_link "New Defence Request"

      fill_in_defence_request_form not_given: true

      click_button "Create Defence Request"

      expect(page).to have_css("h1.detainee", text: "Not Given")
      expect(page).to have_css("dl.labels dd", text: "Not Given", count: 2)
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
      within ".detainee" do
        choose "defence_request_appropriate_adult_true"
      end

      expect(page).
        to_not have_css "#defence_request_appropriate_adult_reason[disabled]"
    end
  end

  context "with requests they are assigned to" do
    context "and requests not yet queued" do
      specify "can select \"not given\" for name, dob and address", js: true do
        cso_user = create :cso_user
        create :defence_request

        login_with cso_user
        click_link "Edit"
        fill_in_defence_request_form edit: true
        click_button "Update Defence Request"

        expect(page).to have_content "Defence Request successfully updated"
        expect(page).to have_content "Mannie Badder"
        click_link "Edit"
        check "defence_request_detainee_name_not_given"
        click_button "Update Defence Request"
        expect(page).to have_content "Defence Request successfully updated"
        expect(page).to_not have_content "Mannie Badder"
      end

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
          fill_in "defence_request_date_of_birth_day", with: "MOOOSE ON THE LOOOSE!?!"
        end
        click_button "Update Defence Request"

        expect(page).to have_content "You need to fix the errors on this page before continuing"
        expect(page).to have_content "Date of Birth: Invalid Date, Day is not a number"
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

    context "with accepted requests", js: true do
      specify "can not edit the expected arrival time from request show page" do
        cso_user = create :cso_user
        create :defence_request, :accepted

        login_with cso_user
        click_link "Show"
        click_link "Interview"

        expect(page).to_not have_selector ".time-of-arrival"
      end

      specify "can mark the request as completed" do
        cso_user = create :cso_user
        create :defence_request, :accepted

        login_with cso_user
        click_button "Complete"

        expect(page).to have_content "Defence Request successfully completed"
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
        :with_detainee_address,
        :with_circumstance_of_arrest,
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

  specify "can follow a link back to the dashboard" do
    cso_user = create :cso_user
    create :defence_request

    login_with cso_user
    click_link "Show"

    click_link "< Back to requests"
    expect(page).to have_content "Custody Suite Officer Dashboard"
  end
end
