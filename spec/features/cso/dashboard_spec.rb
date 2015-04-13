require "rails_helper"

RSpec.feature "Custody Suite Officers viewing their dashboard" do
  include ActiveJobHelper
  include DashboardHelper

  specify "can see all active defence requests in chronological order" do
    cso_user = create :cco_user
    first_acknowledged_defence_request = create :defence_request, :acknowledged
    second_acknowledged_defence_request = create(
      :defence_request,
      :acknowledged,
      created_at: first_acknowledged_defence_request.created_at + 1.hour
    )

    login_with_role "cso", cso_user.uid

    expect(
      element_order_correct?(
        "defence_request_#{first_acknowledged_defence_request.id}",
        "defence_request_#{second_acknowledged_defence_request.id}"
      )
    ).to eq true
  end

  specify "can send a draft case for processing" do
    cso_user = create :cco_user
    create :defence_request, :draft

    login_with_role "cso", cso_user.uid
    click_button "Send for Processing"

    expect(page).
      to have_content "Defence Request successfully sent for processing"
  end

  specify "are shown an error message if a case cannot be sent for processing" do
    stub_defence_request_with method: :queue, value: false
    cso_user = create :cco_user
    create :defence_request, :draft

    login_with_role "cso", cso_user.uid
    click_button "Send for Processing"

    expect(page).to have_content "Defence Request was not sent for processing"
  end

  xspecify "can resend case details of an defence request to the assigned solicitor", js: true do
    visit defence_requests_path

    within ".accepted-defence-request" do
      click_button "Resend details"
    end

    page.execute_script "window.confirm"

    expect(page).to have_content("Details successfully sent")
    expect_email_with_case_details_to_have_been_sent_to_assigned_solicitor
  end

  specify "can abort queued defence request", js: true do
    cso_user = create :cco_user
    create :defence_request, :queued

    login_with_role "cso", cso_user.uid
    abort_defence_request

    expect(page).to have_content "Defence Request successfully aborted"
  end

  specify "can abort acknowledged defence request", js: true do
    cso_user = create :cco_user
    create :defence_request, :acknowledged

    login_with_role "cso", cso_user.uid
    abort_defence_request

    expect(page).to have_content "Defence Request successfully aborted"
  end

  specify "can abort accepted defence request", js: true do
    cso_user = create :cco_user
    create :defence_request, :accepted

    login_with_role "cso", cso_user.uid
    abort_defence_request

    expect(page).to have_content "Defence Request successfully aborted"
  end

  def element_order_correct?(first_element, second_element)
    !!(/#{first_element}.*#{second_element}/m =~ page.body)
  end
end
