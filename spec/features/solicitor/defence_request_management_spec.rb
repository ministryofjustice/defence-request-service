require 'rails_helper'

RSpec.feature "Solicitors managing defence requests" do

  let!(:solicitor_dr) { create(:defence_request, :accepted) }
  let!(:dr2) { create(:defence_request, :accepted) }
  let!(:aborted_dr) { create(:defence_request, :aborted, solicitor: solicitor_dr.solicitor) }

  before :each do
    login_as_user(solicitor_dr.solicitor.email)
  end

  context "with cases they are assigned to" do

    specify "can see the show page of the request" do
      visit defence_requests_path
      within ".accepted-defence-request" do
        click_link("Show")
      end

      expect(page).to have_content("Case Details")
      expect(page).to have_content(solicitor_dr.solicitor_name)
      expect(page).to have_link("Dashboard")
    end

    specify "can edit the expected arrival time from the show page of the request" do
      visit defence_requests_path
      within ".accepted-defence-request" do
        click_link("Show")
      end

      within ".time-of-arrival" do
        fill_in 'defence_request[solicitor_time_of_arrival][day]', with: '01'
        fill_in 'defence_request[solicitor_time_of_arrival][month]', with: '01'
        fill_in 'defence_request[solicitor_time_of_arrival][year]', with: '2001'
        fill_in 'defence_request[solicitor_time_of_arrival][hour]', with: '01'
        fill_in 'defence_request[solicitor_time_of_arrival][min]', with: '01'
      end
      click_button "Add Expected Time of Arrival"

      expect(page).to have_content("Defence Request successfully updated with solicitor estimated time of arrival")

      within "tr.solicitor-time-of-arrival" do
        expect(page).to have_content("1 January 2001 - 01:01")
      end
    end

    specify "are shown a message if the time of arrival cannot be updated due to errors" do
      visit defence_requests_path
      within ".accepted-defence-request" do
        click_link("Show")
      end

      within ".time-of-arrival" do
        fill_in 'defence_request[solicitor_time_of_arrival][day]', with: 'I'
        fill_in 'defence_request[solicitor_time_of_arrival][month]', with: 'AM'
        fill_in 'defence_request[solicitor_time_of_arrival][year]', with: 'VERY'
        fill_in 'defence_request[solicitor_time_of_arrival][hour]', with: 'VERY'
        fill_in 'defence_request[solicitor_time_of_arrival][min]', with: 'BROKEN'
      end
      click_button "Add Expected Time of Arrival"

      expect(page).to have_content(["Invalid Date or Time",
                                   "Day is not a number",
                                   "Month is not a number",
                                   "Year is not a number",
                                   "Hour is not a number",
                                   "Min is not a number"].join(", "))
    end
  end

  context "cases they are were assigned to, that are closed" do
    specify "can see the feedback page and \"call Call Centre\" message" do
      visit defence_request_path(aborted_dr)
      expect(page).to_not have_content("Case Details")
      expect(page).to_not have_content(aborted_dr.solicitor_name)
      expect(page).to have_link("Dashboard")
      expect(page).to have_content("This case has been aborted for the following reason")
      expect(page).to have_content(aborted_dr.reason_aborted)
      expect(page).to have_content("Please call the Call Centre on 0999 999 9999") #TODO: this needs filling in
    end
  end

  context "with cases they are not assigned to" do
    specify  "can not see the show page" do
      visit defence_request_path(dr2)
      expect(page).to have_content("You are not authorised to perform this action")
    end
  end
end
