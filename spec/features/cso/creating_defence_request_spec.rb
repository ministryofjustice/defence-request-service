require "rails_helper"

RSpec.feature "Custody Suite Officers creating defence requests" do
  specify "creating a blank defence request displays all required validation errors" do
    cso_user = create :cso_user

    login_with cso_user
    click_link "New request"

    click_button "Create Defence Request"

    expect(current_path).to eq("/defence_requests")
    expect(page).to have_content "You need to fix the errors on this page before continuing"

    ["Detainee name", "Address", "Date of Birth", "Offences", "Custody number", "Gender", "Arrival time"].each do |field_name|
      expect(page).to have_css(".error-summary li", text: "#{field_name}: can't be blank")
    end
  end

  specify "can select \"not specified\" for gender" do
    cso_user = create :cso_user

    login_with cso_user
    click_link "New request"

    fill_in_defence_request_form gender: "Not specified"

    click_button "Create Defence Request"

    expect(page).to have_css("dl.labels dd", text: "Not specified")
  end

  specify "can select \"not given\" for name, dob and address" do
    cso_user = create :cso_user

    login_with cso_user
    click_link "New request"

    fill_in_defence_request_form not_given: true

    click_button "Create Defence Request"

    expect(page).to have_css("h1.detainee", text: "not given")
    expect(page).to have_css("dl.labels dd", text: "not given", count: 2)
  end

  specify "can not see a DSCC field on the defence request form" do
    cso_user = create :cso_user

    login_with cso_user
    click_link "New request"
    fill_in_defence_request_form
    click_button "Create Defence Request"
  end

  specify "can not see the solicitor time of arrival field on the defence request form" do
    cso_user = create :cso_user

    login_with cso_user
    click_link "New request"

    expect(page).not_to have_field "Expected Solicitor Time of Arrival"
  end

  specify "appropriate_adult toggles appropriate_adult_reason", js: true do
    cso_user = create :cso_user
    login_with cso_user
    click_link "New request"
    within ".detainee" do
      choose "defence_request_appropriate_adult_true"
    end

    expect(page).
      to_not have_css "#defence_request_appropriate_adult_reason[disabled]"
  end
end
