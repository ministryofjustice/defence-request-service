require "rails_helper"

RSpec.shared_examples "setting, changing and validating interview time" do
  specify "can set new interview time to an arbitrary date" do
    create_and_display_defence_request

    fill_date_and_time("14", "05", "4 June 2015")

    click_button "Save interview time"

    expect(page).to have_content("Interview at 14:05 4 June 2015")
  end

  specify "can change interview time to an arbitrary date" do
    create_and_display_defence_request(true)

    within "div#interview" do
      click_link "Change this"
    end

    fill_date_and_time("16", "05", "5 June 2015")

    click_button "Save interview time"

    expect(page).to have_content("Interview at 16:05 5 June 2015")
  end

  specify "gets an error if not all the fields are correctly provided" do
    create_and_display_defence_request

    fill_date_and_time(nil, nil, "5 June 2015")

    within "div#interview" do
      click_button "Save interview time"
    end

    content = "Check that you’ve given a valid interview time (eg 23 10) - please give hour, minutes and date (DD/MM/YYYY)"
    expect(page).to have_content content
  end

  def create_and_display_defence_request(interview_time_set = false)
    cso = create :cso_user

    traits = [ :acknowledged ]
    traits << :interview_start_time if interview_time_set
    dr = create :defence_request, *traits, custody_suite_uid: cso.organisation["uid"]

    login_as_cso(cso)

    visit "/defence_requests/#{dr.id}"
  end

  def fill_date_and_time(hour, min, date)
    fill_in("defence_request_interview_start_time_hour", with: hour) unless hour.nil?
    fill_in("defence_request_interview_start_time_min", with: min) unless min.nil?
    fill_in("defence_request_interview_start_time_date", with: date) unless date.nil?
  end
end

RSpec.feature "Custody Suite Officers changing interview time for a defence request" do
  context "with javascript enabled", js: true do
    include_examples "setting, changing and validating interview time"
  end

  context "with javascript disabled" do
    include_examples "setting, changing and validating interview time"
  end
end
