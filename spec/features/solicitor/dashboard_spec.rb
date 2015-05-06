require "rails_helper"

RSpec.feature "Solicitors viewing their dashboard" do
  include DashboardHelper

  context "tabs" do

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

    let!(:completed_not_accepted_defence_request) {
      create :defence_request, :completed, offences: "Genocide"
    }

    let!(:solicitor_user) {
      create :solicitor_user
    }

    specify "can see active and closed tabs" do
      login_with solicitor_user
      expect(page).to have_link("Active (1)")
      expect(page).to have_link("Closed (1)")
    end

    context "active" do
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

    context "closed" do
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

  context "when the dashboard refreshes to update defence request information" do
    specify "they can still only see requests the they have accepted", js: true, short_dashboard_refresh: true do
      solicitor_user = create :solicitor_user
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
