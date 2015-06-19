require "rails_helper"

RSpec.feature "Custody Suite Officers creating defence requests" do
  specify "creating a blank defence request displays all required validation errors" do
    login_and_open_new_defence_request_page

    click_button "Create request"

    expect(current_path).to eq("/defence_requests")
    expect(page).to have_content "You need to fix the errors on this page before continuing"

    expect(page).to have_css(".error-summary li", text: "You must give the detainee's name or select 'Not given'")
    expect(page).to have_css(".error-summary li", text: "You must select 'Not Given' if the detainee's address is unknown")
    expect(page).to have_css(".error-summary li", text: "You must give the detainee's date of birth or select 'Not given'")
    expect(page).to have_css(".error-summary li", text: "You must give at least one offence with which the detainee is charged")
    expect(page).to have_css(".error-summary li", text: "You must give a custody number")
    expect(page).to have_css(".error-summary li", text: "You must describe the detainee's gender or select 'Unspecified'")
  end

  specify "can select \"not specified\" for gender" do
    login_and_open_new_defence_request_page

    fill_in_defence_request_form gender: "Unspecified"

    click_button "Create request"

    expect(page).to have_css("dl.labels dd", text: "Unspecified")
  end

  specify "can select \"transgender\" for gender" do
    login_and_open_new_defence_request_page

    fill_in_defence_request_form gender: "Transgender"

    click_button "Create request"

    expect(page).to have_css("dl.labels dd", text: "Transgender")
  end

  specify "can select \"not given\" for name, dob and address" do
    login_and_open_new_defence_request_page

    fill_in_defence_request_form not_given: true

    click_button "Create request"

    expect(page).to have_css("h2", text: "Name not given")
    expect(page).to have_css("dl.labels dd", text: "Not given", count: 2)
  end

  #Fixme this test doesn't do what it says
  specify "can not see a DSCC field on the defence request form" do
    login_and_open_new_defence_request_page

    fill_in_defence_request_form
    click_button "Create request"
  end

  specify "can not see the solicitor time of arrival field on the defence request form" do
    login_as_cso

    expect(page).not_to have_field "Expected Solicitor Time of Arrival"
  end

  specify "appropriate_adult toggles appropriate_adult_reason", js: true do
    login_and_open_new_defence_request_page
    fill_in_defence_request_form
    within ".detainee" do
      choose "defence_request_appropriate_adult_true"
      choose "defence_request_appropriate_adult_reason_detainee_juvenile"
    end
    click_button "Create request"

    expect(page).to have_content "Check the request"
    expect(page).to have_content "Yes – because the detainee is a juvenile"
  end

  specify "is prompted to check the request after successfully filling in the form" do
    login_and_open_new_defence_request_page

    fill_in_defence_request_form
    click_button "Create request"

    expect(page).to have_css("h1", "Check the request")
  end

  def login_and_open_new_defence_request_page
    login_as_cso
    click_link "New request"
  end
end
