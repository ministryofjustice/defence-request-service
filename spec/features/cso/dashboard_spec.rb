require "rails_helper"

RSpec.feature "Custody Suite Officers viewing their dashboard" do
  include ActiveJobHelper
  include DashboardHelper

  let(:cso_user) { create :cso_user }
  let(:custody_suite_uid) { cso_user.organisation["uid"] }

  specify "can see all active defence requests in chronological order" do
    first_acknowledged_defence_request = create(
      :defence_request,
      :acknowledged,
      custody_suite_uid: custody_suite_uid
    )
    second_acknowledged_defence_request = create(
      :defence_request,
      :acknowledged,
      custody_suite_uid: custody_suite_uid,
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

  context "tabs" do

    let!(:active_defence_request) { create(
      :defence_request,
      :accepted,
      custody_suite_uid: custody_suite_uid,
      offences: "Other cod-related offences"
    ) }

    let!(:other_active_defence_request) {
      create :defence_request, :queued, custody_suite_uid: custody_suite_uid, offences: "Use of edible crab as bait"
    }

    let!(:completed_defence_request) {
      create(
        :defence_request,
        :completed,
        custody_suite_uid: custody_suite_uid,
        offences: "Illegal strengthening bag"
      )
    }

    specify "can see active and closed tabs"  do
      login_with  cso_user
      expect(page).to have_link("Opened (2)")
      expect(page).to have_link("Completed (1)")
    end

    context "active" do
      specify "can only see active requests" do
        login_with  cso_user

        click_link "Opened (2)"
        expect(page).to have_content active_defence_request.detainee_name
        expect(page).to have_content other_active_defence_request.detainee_name
        expect(page).to_not have_content completed_defence_request.detainee_name
      end
    end

    context "closed" do
      specify "can only see closed requests" do
        login_with  cso_user

        click_link "Completed (1)"
        expect(page).to have_content completed_defence_request.detainee_name
        expect(page).to_not have_content active_defence_request.detainee_name
        expect(page).to_not have_content other_active_defence_request.detainee_name
      end
    end
  end

  def element_order_correct?(first_element, second_element)
    !!(/#{first_element}.*#{second_element}/m =~ page.body)
  end
end
