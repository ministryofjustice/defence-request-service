require "rails_helper"

RSpec.feature "Custody Center Operatives viewing their dashboard" do
  include ActiveJobHelper
  include DashboardHelper

  specify "view queued, acknowledged and aborted defence requests tables" do
    cco_user = create :cco_user
    aborted_defence_request = create :defence_request, :aborted
    acknowledged_defence_request = create :defence_request, :acknowledged
    queued_defence_request = create :defence_request, :queued

    login_with_role "cco", cco_user.uid

    expect(page).to have_content aborted_defence_request.solicitor_name
    expect(page).to have_content acknowledged_defence_request.solicitor_name
    expect(page).to have_content queued_defence_request.solicitor_name
  end

  specify "view refreshed data on the dashboard with after a period", js: true do
    cco_user = create :cco_user
    acknowledged_defence_request = create :defence_request, :acknowledged
    queued_defence_request = create :defence_request, :queued

    login_with_role "cco", cco_user.uid

    acknowledged_defence_request.update!(
      solicitor_name: "Queued Req. Updated Solicitor Name"
    )
    queued_defence_request.update!(
      solicitor_name: "Acknowledged Req. Updated Solicitor Name"
    )

    refresh_dashboard

    expect(page).to have_content "Queued Req. Updated Solicitor Name"
    expect(page).to have_content "Acknowledged Req. Updated Solicitor Name"
  end

  xspecify "can resend case details of an defence request to the assigned solicitor", js: true do
    cco_user = create :cco_user
    create :defence_request, :accepted

    login_with_role "cco", cco_user.uid
    click_button "Resend details"

    refresh_dashboard

    expect(page).to have_content "Details successfully sent"
    expect_email_with_case_details_to_have_been_sent_to_assigned_solicitor
  end

  xspecify "are shown an error message if case details cannot be resent", js: true do
    stub_defence_request_with method: :resend_details, value: false
    cco_user = create :cco_user
    create :defence_request, :with_solicitor, :accepted

    login_with_role "cco", cco_user.uid
    click_button "Resend details"
    page.execute_script "window.confirm"
    wait_for_dashboard_refresh

    expect(page).to have_content "Details were not sent"
  end
end
