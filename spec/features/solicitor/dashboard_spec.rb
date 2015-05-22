require "rails_helper"

RSpec.feature "Solicitors viewing their dashboard" do
  include DashboardHelper

  let!(:law_firm) { create :organisation, :law_firm }

  let!(:solicitor_user) {
    create :solicitor_user, organisation_uids: [law_firm.uid]
  }


  let(:auth_api_mock_setup) {
    {
      organisation: {
        law_firm.uid => law_firm
      }
    }
  }

  context "tabs" do

    let!(:completed_not_accepted_defence_request) {
      create :defence_request, :completed, offences: "Genocide"
    }

    let!(:active_accepted_defence_request) { create(
      :defence_request,
      :accepted,
      solicitor_uid: solicitor_user.uid,
      organisation_uid: solicitor_user.organisation_uids.first,
      offences: "Arson"
    ) }

    let!(:active_not_accepted_defence_request) {
      create :defence_request, offences: "Extortion"
    }

    let!(:completed_accepted_defence_request) {
      create(
        :defence_request,
        :completed,
        solicitor_uid: solicitor_user.uid,
        organisation_uid: solicitor_user.organisation_uids.first,
        offences: "Theft"
      )
    }

    specify "can see active and closed tabs", :mock_auth_api do
      login_with solicitor_user
      expect(page).to have_link("Active (1)")
      expect(page).to have_link("Closed (1)")
    end

    context "active", :mock_auth_api do
      before :each do
        login_with solicitor_user
        click_link("Active (1)")
      end

      specify "can only see active requests that they have accepted" do
        expect(page).to have_content active_accepted_defence_request.offences
        expect(page).to_not have_content active_not_accepted_defence_request.offences
        expect(page).to_not have_content completed_accepted_defence_request.offences
        expect(page).to_not have_content completed_not_accepted_defence_request.offences
      end
    end

    context "closed", :mock_auth_api do
      before :each do
        login_with solicitor_user
        click_link("Closed (1)")
      end

      specify "can only see completed requests that they have accepted" do
        expect(page).to_not have_content active_accepted_defence_request.offences
        expect(page).to_not have_content active_not_accepted_defence_request.offences
        expect(page).to have_content completed_accepted_defence_request.offences
        expect(page).to_not have_content completed_not_accepted_defence_request.offences
      end
    end
  end

  context "when the dashboard refreshes to update defence request information", :mock_auth_api do
    specify "they can still only see requests the they have accepted", js: true, short_dashboard_refresh: true do
      accepted_defence_request = create(
        :defence_request,
        :accepted,
        solicitor_uid: solicitor_user.uid,
        organisation_uid: solicitor_user.organisation_uids.first
      )
      acknowledged_defence_request = create :defence_request, :acknowledged

      login_with solicitor_user

      expect(page).to have_content(accepted_defence_request.detainee_name)
      expect(page).to_not have_content(acknowledged_defence_request.detainee_name)

      refresh_dashboard

      expect(page).to have_content(accepted_defence_request.detainee_name)
      expect(page).to_not have_content(acknowledged_defence_request.detainee_name)
    end
  end
end
