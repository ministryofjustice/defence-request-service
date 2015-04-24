require "rails_helper"

RSpec.feature "Call Center Operatives managing defence requests" do
  context "with any request" do
    specify "can see the show page of the request" do
      cco_user = create :cco_user
      accepted_defence_request = create :defence_request, :accepted

      login_with cco_user
      click_link "Show"

      expect(page).to have_content accepted_defence_request.solicitor_name
    end

    specify "can not edit expected time of arrival from the request show page" do
      cco_user = create :cco_user
      create :defence_request, :accepted

      login_with cco_user
      click_link "Show"

      expect(page).to_not have_selector ".time-of-arrival"
    end
  end

  context "with requests they are assigned to" do
    context "that have not yet been acknowledged" do
      specify "cannot edit the request" do
        cco_user = create :cco_user
        create :defence_request, :queued, cco_uid: cco_user.uid

        login_with cco_user

        expect(page).not_to have_link "Edit"
      end

      specify "can acknowledge the request" do
        cco_user = create :cco_user
        create :defence_request, :queued, cco_uid: cco_user.uid

        login_with cco_user
        click_button "Acknowledge"

        expect(page).to have_content "Defence Request successfully acknowledged"
      end

      specify "are shown a message if the request cannot be acknowledged" do
        stub_defence_request_with method: :acknowledge, value: false
        cco_user = create :cco_user
        create :defence_request, :queued

        login_with cco_user
        click_button "Acknowledge"

        expect(page).to have_content "Defence Request was not acknowledged"
      end

      specify "cannot mark the request as accepted" do
        cco_user = create :cco_user
        create :defence_request, :queued

        login_with cco_user

        expect(page).to_not have_button "Accepted"
      end
    end

    context "that have been acknowledged by this cco" do
      specify "can edit the solicitors details on the request" do
        cco_user = create :cco_user
        create :defence_request, :acknowledged, cco_uid: cco_user.uid

        login_with cco_user
        click_link "Edit"
        fill_in "Full Name", with: "Henry Billy Bob"
        fill_in "Telephone number", with: "00112233445566"
        click_button "Update Defence Request"

        expect(page).to have_content "Henry Billy Bob"
        expect(page).to have_content "00112233445566"
      end

      specify "can add/edit the DSCC number on the request" do
        cco_user = create :cco_user
        create(
          :defence_request,
          :acknowledged,
          cco_uid: cco_user.uid
        )

        login_with cco_user
        click_link "Edit"
        fill_in "DSCC number", with: "NUMBERWANG"
        click_button "Update Defence Request"

        expect(page).to have_content "Defence Request successfully updated"
      end

      specify "can mark the request as accepted its edit page while adding a dscc number" do
        cco_user = create :cco_user
        acknowledged_defence_request = create(
          :defence_request,
          :acknowledged,
          cco_uid: cco_user.uid
        )

        login_with cco_user
        click_link "Edit"
        fill_in "DSCC number", with: "123456"
        click_button "Update and Accept"

        expect(page).
          to have_content acknowledged_defence_request.solicitor_name
      end

      specify "can not choose 'Update and Accept' from the request's edit page without adding a dscc number" do
        cco_user = create :cco_user
        create(
          :defence_request,
          :acknowledged,
          cco_uid: cco_user.uid
        )

        login_with cco_user
        click_link "Edit"
        click_button "Update and Accept"

        expect(page).
          to have_content "Defence Request was not updated or marked as accepted"
      end

      context "that have a dscc number" do
        specify "can accept the request from the dashboard" do
          cco_user = create :cco_user
          create(
            :defence_request,
            :acknowledged,
            dscc_number: "012345",
            cco_uid: cco_user.uid
          )

          login_with cco_user
          click_button "Accepted"

          expect(page).to have_content "Defence Request was marked as accepted"
        end

        specify "are shown an error if the request cannot be accepted" do
          stub_defence_request_with method: :accept, value: false
          cco_user = create :cco_user
          create(
            :defence_request,
            :acknowledged,
            dscc_number: "012345",
            cco_uid: cco_user.uid
          )

          login_with cco_user
          click_button "Accepted"

          expect(page).
            to have_content "Defence Request was not marked as accepted"
        end
      end

      context "that have the 'duty' solicitor type" do
        specify "can't  mark the request as accepted from the dashboard without solicitor details" do
          cco_user = create :cco_user
          create(
            :defence_request,
            :duty_solicitor,
            :acknowledged,
            cco_uid: cco_user.uid
          )

          login_with cco_user

          expect(page).to_not have_button "Accepted"
        end

        specify "can only mark the request as accepted from the edit page with solicitor details" do
          cco_user = create :cco_user
          create(
            :defence_request,
            :duty_solicitor,
            :acknowledged,
            cco_uid: cco_user.uid
          )

          login_with cco_user
          click_link "Edit"
          fill_in "Full Name", with: "Dodgy Dave"
          fill_in "Name of firm", with: ""
          click_button "Update and Accept"

          expect(page).
            to have_content "Defence Request was not updated or marked as accepted"
        end

        specify "can only mark the request as accepted from the edit page with a dscc number" do
          cco_user = create :cco_user
          create(
            :defence_request,
            :duty_solicitor,
            :acknowledged,
            cco_uid: cco_user.uid
          )

          login_with cco_user
          click_link "Edit"
          fill_in "Full Name", with: "Dodgy Dave"
          fill_in "Name of firm", with: "Innocent your honour"
          fill_in "DSCC number", with: ""
          click_button "Update and Accept"

          expect(page).
            to have_content "Defence Request was not updated or marked as accepted"
        end
      end
    end
  end

  context "that have been marked as accepted" do
    specify "can edit the expected time of arrival on the request" do
      cco_user = create :cco_user
      create(
        :defence_request,
        :accepted,
        cco_uid: cco_user.uid
      )

      login_with cco_user
      click_link "Edit"
      fill_in "defence_request_solicitor_time_of_arrival_day", with: "01"
      fill_in "defence_request_solicitor_time_of_arrival_month", with: "01"
      fill_in "defence_request_solicitor_time_of_arrival_year", with: "2001"
      fill_in "defence_request_solicitor_time_of_arrival_hour", with: "01"
      fill_in "defence_request_solicitor_time_of_arrival_min", with: "01"
      click_button "Update Defence Request"
      click_link "Show"

      expect(page).to have_content "1 January 2001 - 01:01"
    end
  end
end
