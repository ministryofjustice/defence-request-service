require "rails_helper"

RSpec.feature "Custody Suite Officers checking and submitting defence requests" do
  specify "can edit detainee details" do
    login_and_create_defence_request

    within ".detainee-details" do
      click_link "Change this"
    end

    fill_in "defence_request_detainee_address", with: "Changed address"
    click_button "Save changes"

    expect(page).to have_content("Changed address")
  end

  specify "can edit detention details" do
    login_and_create_defence_request

    within ".detention-details" do
      click_link "Change this"
    end

    fill_in "defence_request_custody_number", with: "New number"
    click_button "Save changes"

    expect(page).to have_content("New number")
  end

  specify "can submit the defence request" do
    login_and_create_defence_request

    click_button "Submit request"

    expect(page).to have_css(".defence_request .name", "Mannie Badder")
    expect(page).to have_css(".defence_request .state", "Submitted")
  end

  specify "can abandon the defence request by cancelling" do
    login_and_create_defence_request

    click_link "Cancel and delete all details"

    expect(page).to have_css(".defence_request", count: 0)
  end

  def login_and_create_defence_request
    login_as_cso

    click_link "New request"
    fill_in_defence_request_form
    click_button "Create Defence Request"
  end
end