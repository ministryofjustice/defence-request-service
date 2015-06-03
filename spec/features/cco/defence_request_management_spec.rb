require "rails_helper"

RSpec.feature "Call Center Operatives managing defence requests" do
  context "with any request" do
    specify "can see the show page of the request" do
      cco_user = create :cco_user
      accepted_defence_request = create :defence_request, :accepted

      login_with cco_user
      click_link "Show"

      expect(page).to have_content accepted_defence_request.detainee_name
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
      let(:law_firm) {
        create(:organisation)
      }

      let(:auth_api_mock_setup) do
        {
          organisations: {
            { types: [:law_firm] } => [law_firm]
          },
          organisation: {
            law_firm.uid => law_firm
          }
        }
      end

      specify "cannot edit the request" do
        cco_user = create :cco_user
        create :defence_request, :queued, cco_uid: cco_user.uid

        login_with cco_user

        expect(page).not_to have_link "Edit"
      end

      specify "can acknowledge the request", :mock_auth_api do
        cco_user = create :cco_user
        dr =  create :defence_request, :queued, cco_uid: cco_user.uid

        login_with cco_user
        click_button "Acknowledge"

        expect(page).to have_content "Defence Request successfully acknowledged"

        click_link "Show"
        expect(page).to have_content "#{dr.dscc_number}"
      end

      specify "are shown a message if the request cannot be acknowledged" do
        stub_defence_request_transition_strategy(
          strategy: DefenceRequestTransitions::Acknowledge,
          method: :complete,
          value: false
        )
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
      specify "can transition the request to accepted from its edit page" do
        cco_user = create :cco_user
        acknowledged_defence_request = create(
          :defence_request,
          :acknowledged,
          :with_dscc_number,
          :with_arrest_time,
          :with_detention_authorised_time,
          cco_uid: cco_user.uid
        )

        login_with cco_user
        click_link "Edit"
        click_button "Update and Accept"

        expect(page).
          to have_content acknowledged_defence_request.detainee_name
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
            :with_dscc_number,
            cco_uid: cco_user.uid
          )

          login_with cco_user
          click_button "Accepted"

          expect(page).to have_content "Defence Request was marked as accepted"
        end

        specify "are shown an error if the request cannot be accepted" do
          stub_defence_request_transition_strategy(
            strategy: DefenceRequestTransitions::Accept,
            method: :complete,
            value: false
          )
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
    end
  end

  context "that have been marked as accepted" do
    specify "can edit the expected time of arrival on the request" do
      cco_user = create :cco_user
      create(
        :defence_request,
        :accepted,
        :with_arrest_time,
        :with_detention_authorised_time,
        cco_uid: cco_user.uid
      )

      login_with cco_user
      click_link "Edit"
      fill_in "defence_request_solicitor_time_of_arrival_date", with: "01 Jan 2001"
      fill_in "defence_request_solicitor_time_of_arrival_hour", with: "01"
      fill_in "defence_request_solicitor_time_of_arrival_min", with: "01"
      click_button "Save changes"

      expect(page).to have_content "01:01 1 January 2001"
    end
  end
end
