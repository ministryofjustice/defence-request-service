require "rails_helper"

RSpec.feature "Solicitors managing defence requests" do
  context "with cases they are assigned to" do
    specify "can see the show page of the request" do
      solicitor_user = create :solicitor_user
      accepted_defence_request = create(
        :defence_request,
        :accepted,
        solicitor_uid: solicitor_user.uid,
        organisation_uid: solicitor_user.organisation_uids.first
      )

      login_with solicitor_user
      click_link "Show"

      expect(page).to have_content accepted_defence_request.solicitor_name
    end

    specify "can edit the expected arrival time from the show page of the request" do
      solicitor_user = create :solicitor_user
      create :defence_request, :accepted,
        solicitor_uid: solicitor_user.uid,
        organisation_uid: solicitor_user.organisation_uids.first

      login_with solicitor_user
      click_link "Show"
      within ".time-of-arrival" do
        fill_in "defence_request[solicitor_time_of_arrival][day]", with: "01"
        fill_in "defence_request[solicitor_time_of_arrival][month]", with: "01"
        fill_in "defence_request[solicitor_time_of_arrival][year]", with: "2001"
        fill_in "defence_request[solicitor_time_of_arrival][hour]", with: "01"
        fill_in "defence_request[solicitor_time_of_arrival][min]", with: "01"
      end
      click_button "Add Expected Time of Arrival"

      expect(page).to have_content "1 January 2001 - 01:01"
    end

    specify "are shown a message if the time of arrival cannot be updated due to errors" do
      solicitor_user = create :solicitor_user
      create :defence_request, :accepted,
        solicitor_uid: solicitor_user.uid,
        organisation_uid: solicitor_user.organisation_uids.first

      login_with solicitor_user
      click_link "Show"
      within ".time-of-arrival" do
        fill_in "defence_request[solicitor_time_of_arrival][day]", with: "I"
        fill_in "defence_request[solicitor_time_of_arrival][month]", with: "AM"
        fill_in "defence_request[solicitor_time_of_arrival][year]", with: "VERY"
        fill_in "defence_request[solicitor_time_of_arrival][hour]", with: "VERY"
        fill_in "defence_request[solicitor_time_of_arrival][min]", with: "BROKEN"
      end
      click_button "Add Expected Time of Arrival"

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
