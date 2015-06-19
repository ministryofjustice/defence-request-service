require "rails_helper"

RSpec.feature "Custody Suite Officers editing defence requests" do

  specify "can edit detainee details" do
    login_and_view_defence_request

    within ".detainee-details" do
      click_link "Change this"
    end

    fill_in "defence_request_detainee_address", with: "Changed address"
    click_button "Save changes"

    expect(page).to have_content("Changed address")
  end

  specify "can edit case details" do
    login_and_view_defence_request

    click_link "Case details"
    within ".case-details" do
      click_link "Change this"
    end

    fill_in "defence_request_custody_number", with: "New number"
    click_button "Save changes"

    expect(page).to have_content("New number")
  end

  def login_and_view_defence_request
    cso = create :cso_user
    defence_request = create :defence_request, :queued, custody_suite_uid: cso.organisation["uid"]

    login_as_cso(cso)

    within "tr#defence_request_#{defence_request.id} td.actions" do
      find("a").click
    end
  end
end
