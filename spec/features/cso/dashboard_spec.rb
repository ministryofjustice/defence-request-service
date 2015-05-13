require "rails_helper"

RSpec.feature "Custody Suite Officers viewing their dashboard" do
  include ActiveJobHelper
  include DashboardHelper

  specify "can see all active defence requests in chronological order" do
    cso_user = create :cso_user
    first_acknowledged_defence_request = create :defence_request, :acknowledged
    second_acknowledged_defence_request = create(
      :defence_request,
      :acknowledged,
      created_at: first_acknowledged_defence_request.created_at + 1.hour
    )

    login_with cso_user

    expect(
      element_order_correct?(
        "defence_request_#{first_acknowledged_defence_request.id}",
        "defence_request_#{second_acknowledged_defence_request.id}"
      )
    ).to eq true
  end

  specify "can send a draft case for processing" do
    cso_user = create :cso_user
    create :defence_request, :draft

    login_with cso_user
    click_button "Send for Processing"

    expect(page).
      to have_content "Defence Request successfully sent for processing"
  end

  specify "are shown an error message if a case cannot be sent for processing" do
    stub_defence_request_transition_strategy(
      strategy: DefenceRequestTransitions::Queue,
      method: :complete,
      value: false
    )
    cso_user = create :cso_user
    create :defence_request

    login_with cso_user
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
    cso_user = create :cso_user
    create :defence_request, :queued

    login_with cso_user
    abort_defence_request

    expect(page).to have_content "Defence Request successfully aborted"
  end

  specify "can abort acknowledged defence request", js: true do
    cso_user = create :cso_user
    create :defence_request, :acknowledged

    login_with cso_user
    abort_defence_request

    expect(page).to have_content "Defence Request successfully aborted"
  end

  specify "can abort accepted defence request", js: true do
    cso_user = create :cso_user
    create :defence_request, :accepted

    login_with cso_user
    abort_defence_request

    expect(page).to have_content "Defence Request successfully aborted"
  end

  context "tabs" do

    let!(:active_defence_request) { create(
      :defence_request,
      :accepted,
      offences: "Other cod-related offences"
    ) }

    let!(:other_active_defence_request) {
      create :defence_request, offences: "Use of edible crab as bait"
    }

    let!(:completed_defence_request) {
      create(
        :defence_request,
        :completed,
        offences: "Illegal strengthening bag"
      )
    }

    specify "can see active and closed tabs"  do
      cso_user = create :cso_user
      login_with  cso_user
      expect(page).to have_link("Active (2)")
      expect(page).to have_link("Closed (1)")
    end

    context "active" do
      specify "can only see active requests" do
        cso_user = create :cso_user
        login_with  cso_user

        click_link "Active (2)"
        expect(page).to have_content active_defence_request.offences
        expect(page).to have_content other_active_defence_request.offences
        expect(page).to_not have_content completed_defence_request.offences
      end
    end

    context "closed" do
      specify "can only see closed requests" do
        cso_user = create :cso_user
        login_with  cso_user

        click_link "Closed (1)"
        expect(page).to have_content completed_defence_request.offences
        expect(page).to_not have_content active_defence_request.offences
        expect(page).to_not have_content other_active_defence_request.offences
      end
    end
  end

  def element_order_correct?(first_element, second_element)
    !!(/#{first_element}.*#{second_element}/m =~ page.body)
  end
end
