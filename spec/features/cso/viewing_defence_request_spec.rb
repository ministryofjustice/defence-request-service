require "rails_helper"

RSpec.feature "Custody Suite Officers viewing defence request" do
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
      :with_investigating_officer
    )

    login_with cso_user
    click_link "❭"

    expect(page).to have_content defence_request.dscc_number
  end

  specify "can follow a link back to the dashboard" do
    cso_user = create :cso_user
    create :defence_request, :queued

    login_with cso_user
    click_link "❭"

    click_link "< Back to requests"
    expect(current_path).to eq("/dashboard")
  end
end