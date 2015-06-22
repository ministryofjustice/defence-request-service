require "rails_helper"

RSpec.feature "Custody Suite Officers viewing defence request" do
  specify "shows all required fields" do
    cso_user = create :cso_user
    defence_request = create(
      :defence_request,
      :accepted,
      :appropriate_adult,
      :interview_start_time,
      :unfit_for_interview,
      :with_detainee_address,
      :with_dscc_number,
      :with_interpreter_required,
      :with_investigating_officer,
      custody_suite_uid: cso_user.organisation["uid"]
    )

    login_with cso_user
    within "tr#defence_request_#{defence_request.id} td.actions" do
      find("a").click
    end

    expect(page).to have_content defence_request.dscc_number
  end

  specify "can follow a link back to the dashboard" do
    cso_user = create :cso_user
    defence_request = create :defence_request, :queued, custody_suite_uid: cso_user.organisation["uid"]

    login_with cso_user
    within "tr#defence_request_#{defence_request.id} td.actions" do
      find("a").click
    end

    click_link "< Back to requests"
    expect(current_path).to eq("/dashboard")
  end

  specify "It sets the first tab as active", js: true do
    cso_user = create :cso_user
    defence_request = create :defence_request, :queued, custody_suite_uid: cso_user.organisation["uid"]

    login_with cso_user
    within "tr#defence_request_#{defence_request.id} td.actions" do
      find("a").click
    end

    visit defence_request_path(defence_request, tab: "googly woogly wooo")
    expect(find(:css, ".tabs").first("li")["class"]).to include "is-active"
  end
end
