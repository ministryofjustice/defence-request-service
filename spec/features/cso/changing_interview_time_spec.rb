require "rails_helper"

RSpec.feature "Custody Suite Officers changing interview time for a defence request" do
  context "with javascript enabled", js: true do
    specify "can set new interview time to an arbitrary date" do
      create_and_display_defence_request

      within "div#interview" do
        fill_in "Hour", with: "14"
        fill_in "Min", with: "05"
        fill_in "defence_request_interview_start_time_date", with: "4 June 2015"
      end

      click_button "Save interview time"

      expect(page).to have_content("Interview at 14:05 4 June 2015")
    end

    specify "can change interview time to an arbitrary date" do
      create_and_display_defence_request(true)

      within "div#interview" do
        click_link "Change this"

        fill_in "Hour", with: "16"
        fill_in "Min", with: "05"
        fill_in "defence_request_interview_start_time_date", with: "5 June 2015"
      end

      click_button "Save interview time"

      expect(page).to have_content("Interview at 16:05 5 June 2015")
    end
  end

  context "with javascript disabled" do
    specify "can set new interview time to an arbitrary date" do
      create_and_display_defence_request

      within "div#interview" do
        fill_in "Hour", with: "14"
        fill_in "Min", with: "05"
        fill_in "defence_request_interview_start_time_date", with: "4 June 2015"
      end

      click_button "Save interview time"

      expect(page).to have_content("Interview at 14:05 4 June 2015")
    end

    specify "can change interview time to an arbitrary date" do
      create_and_display_defence_request(true)

      within "div#interview" do
        click_link "Change this"
      end

      fill_in "Hour", with: "16"
      fill_in "Min", with: "05"
      fill_in "defence_request_interview_start_time_date", with: "5 June 2015"

      click_button "Save interview time"

      expect(page).to have_content("Interview at 16:05 5 June 2015")
    end
  end

  def create_and_display_defence_request(interview_time_set = false)
    traits = [ :acknowledged ]
    traits << :interview_start_time if interview_time_set
    dr = create :defence_request, *traits

    login_as_cso

    visit "/defence_requests/#{dr.id}"
  end
end
