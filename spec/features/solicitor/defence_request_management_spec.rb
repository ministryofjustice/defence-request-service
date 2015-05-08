require "rails_helper"

RSpec.feature "Solicitors managing defence requests" do
  context "with cases they are assigned to" do

    def enter_time(hour:, min:, day: nil, month: nil, year: nil)
      within ".time-of-arrival" do
        fill_in "defence_request[solicitor_time_of_arrival][day]", with: day if day
        fill_in "defence_request[solicitor_time_of_arrival][month]", with: month if month
        fill_in "defence_request[solicitor_time_of_arrival][year]", with: year if year
        fill_in "defence_request[solicitor_time_of_arrival][hour]", with: hour
        fill_in "defence_request[solicitor_time_of_arrival][min]", with: min
      end
    end

    def login_as_solicitor_with_accepted_defence_request
      solicitor_user = create :solicitor_user
      @accepted_defence_request = create(
        :defence_request,
        :accepted,
        solicitor_uid: solicitor_user.uid,
        organisation_uid: solicitor_user.organisation_uids.first
      )

      login_with solicitor_user
    end

    # let!(:solicitor_user){ create :solicitor_user }
    # let!(:accepted_defence_request){ create(
      # :defence_request,
      # :accepted,
      # solicitor_uid: solicitor_user.uid,
      # organisation_uid: solicitor_user.organisation_uids.first
    # ) }

    # context "tabs" do
      # specify "can see active and closed tabs", js: true do
        # login_with solicitor_user
        # click_link "Case Details for #{accepted_defence_request.dscc_number}"
        # expect(page).to have_link("Case Details")
        # expect(page).to have_link("Interview")
      # end

      # context "Case Details tab" do
        # specify "can see the show page of the request" do
          # # login_with solicitor_user
          # # click_link "Case Details for #{accepted_defence_request.dscc_number}"
          # #
          # # expect(page).to have_content accepted_defence_request.solicitor_name
        # end

      # end

      # context "Interview tab" do
        # #SOMETHING HERE
      # end
    # end

    specify "can see the show page of the request" do
      login_as_solicitor_with_accepted_defence_request
      click_link "Case Details for #{@accepted_defence_request.dscc_number}"

      expect(page).to have_content @accepted_defence_request.detainee_name
    end

    specify "can edit the expected arrival time from the show page of the request" do
      login_as_solicitor_with_accepted_defence_request
      click_link "Case Details for #{@accepted_defence_request.dscc_number}"
      click_link "Add an estimated time of arrival"

      expect(page).to have_css ".date-chooser-select.js-only"
      enter_time hour: "01", min: "12"
      click_button "Save"
      today = Date.today.to_s(:full)
      expect( find("#solicitor_time_of_arrival") ).to have_content "#{today} - 01:12"

      click_link "Add an estimated time of arrival"
      enter_time day: "21", month: "11", year: "2002", hour: "01", min: "12"
      click_button "Save"
      expect( find("#solicitor_time_of_arrival") ).to have_content "21 November 2002 - 01:12"

      click_link "Add an estimated time of arrival"
      enter_time day: "02", month: "02", year: "2002", hour: "02", min: "02"
      click_link "Cancel"

      expect( find("#solicitor_time_of_arrival") ).to have_content "21 November 2002 - 01:12"
    end

    specify "can edit the expected arrival time from the show page of the request with JS enabled", js: true do
      login_as_solicitor_with_accepted_defence_request
      click_link "Case Details for #{@accepted_defence_request.dscc_number}"
      click_link "Interview"
      click_link "Add an estimated time of arrival"
      enter_time hour: "23", min: "02"
      click_button "Save"

      today = Date.today.to_s(:full)
      expect( find("#solicitor_time_of_arrival") ).to have_content "#{today} - 23:02"

      click_link "Interview"
      click_link "Add an estimated time of arrival"
      click_link "Tomorrow"
      enter_time hour: "00", min: "03"
      click_button "Save"
      tomorrow = (Date.today + 1).to_s(:full)
      expect( find("#solicitor_time_of_arrival") ).to have_content "#{tomorrow} - 00:03"

      click_link "Interview"
      click_link "Add an estimated time of arrival"
      click_button "Save"
      expect( find("#solicitor_time_of_arrival") ).to have_content "#{tomorrow} - 00:03"

      click_link "Interview"
      click_link "Add an estimated time of arrival"
      click_link "Today"
      enter_time hour: "23", min: "59"
      click_button "Save"
      expect( find("#solicitor_time_of_arrival") ).to have_content "#{today} - 23:59"

      click_link "Interview"
      click_link "Add an estimated time of arrival"
      enter_time day: "21", month: "11", year: "2002", hour: "01", min: "12"
      click_button "Save"
      expect( find("#solicitor_time_of_arrival") ).to have_content "21 November 2002 - 01:12"

      click_link "Interview"
      click_link "Add an estimated time of arrival"
      enter_time day: "02", month: "02", year: "2002", hour: "02", min: "02"
      click_link "Cancel"
      expect( find("#solicitor_time_of_arrival") ).to have_content "21 November 2002 - 01:12"
    end

    specify "are shown a message if the time of arrival cannot be updated due to errors" do
      login_as_solicitor_with_accepted_defence_request
      click_link "Case Details for #{@accepted_defence_request.dscc_number}"
      click_link "Add an estimated time of arrival"
      enter_time day: "i", month: "n", year: "v", hour: "a", min: "lid"
      click_button "Save"

      expect(page).to have_content(
        [
          "Invalid Date or Time",
          "Day is not a number",
          "Month is not a number",
          "Year is not a number",
          "Hour is not a number",
          "Min is not a number"
        ].join(", ")
      )
    end
  end

  context "with cases they are not assigned to" do
    specify  "can not see the show page" do
      solicitor_user = create :solicitor_user
      other_solicitor = create(:solicitor_user)

      defence_request_assigned_to_other_solicitor = create(
        :defence_request,
        :accepted,
        solicitor_uid: other_solicitor.uid,
        organisation_uid: other_solicitor.organisation_uids.first
      )

      login_with solicitor_user
      visit defence_request_path defence_request_assigned_to_other_solicitor

      expect(page).
        to have_content "You are not authorised to perform this action"
    end
  end
end
