require "rails_helper"

RSpec.feature "Custody Suite Officers changing interview time for a defence request" do
  # TODO: check new interview time it rendered when the below story is done:
  # https://trello.com/c/RtWUhXVc/8-3-as-a-cso-i-d-like-to-add-the-interview-time-so-that-the-solicitor-knows-when-the-interview-starts

  specify "can change interview time to an arbitrary date" do
    login_create_and_submit_defence_request

    # navigate to the defence request details page
    find(".cso-defence-requests tbody tr:first-child td.actions a").click

    within "div#interview" do
      fill_in "Hour", with: "14"
      fill_in "Min", with: "05"
      fill_in "defence_request_interview_start_time_date", with: "4 June 2015"
    end

    click_button "Save interview time"

    expect(page).to have_content("Interview start time updated")
  end

  def login_create_and_submit_defence_request
    login_as_cso

    click_link "New request"
    fill_in_defence_request_form
    click_button "Create request"
    click_button "Submit request"
  end
end
