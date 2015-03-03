require 'rails_helper'

RSpec.feature "solicitors managing defence requests" do
  let!(:solicitor_dr) { create(:defence_request, :accepted) }
  let!(:dr2) { create(:defence_request, :accepted) }
  let!(:closed_dr) { create(:defence_request, :closed, solicitor: solicitor_dr.solicitor) }

  before :each do
    login_as_user(solicitor_dr.solicitor.email)
  end

  context "with cases they are assigned to" do

    scenario "they can see the show page" do
      visit defence_requests_path
      within ".accepted-defence-request" do
        click_link("Show")
      end

      expect(page).to have_content("Case Details")
      expect(page).to have_content(solicitor_dr.solicitor_name)
      expect(page).to have_link("Dashboard")
    end

    scenario "they can edit the expected arrival time form the show page" do
      visit defence_requests_path
      within ".accepted-defence-request" do
        click_link("Show")
      end

      within ".time-of-arrival" do
        fill_in 'defence_request_solicitor_time_of_arrival_day', with: '01'
        fill_in 'defence_request_solicitor_time_of_arrival_month', with: '01'
        fill_in 'defence_request_solicitor_time_of_arrival_year', with: '2001'
        fill_in 'defence_request_solicitor_time_of_arrival_hour', with: '01'
        fill_in 'defence_request_solicitor_time_of_arrival_min', with: '01'

        click_button "Add Expected Time of Arrival"
      end

      expect(page).to have_content("Defence Request successfully updated with solicitor estimated time of arrival")

      within "tr.solicitor-time-of-arrival" do
        expect(page).to have_content("1 January 2010 - 12:00")
      end
    end
  end

  context "cases they are were assigned to, that are closed" do
    scenario "they can see the feedback page and 'call Call Centre' message" do
      visit defence_request_path(closed_dr)
      expect(page).to_not have_content("Case Details")
      expect(page).to_not have_content(closed_dr.solicitor_name)
      expect(page).to have_link("Dashboard")
      expect(page).to have_content("This case has been closed with the following feedback")
      expect(page).to have_content(closed_dr.feedback)
      expect(page).to have_content("Please call the Call Centre on 0999 999 9999") #TODO: this needs filling in
    end
  end

  context  "with cases they are NOT assigned to" do
    scenario "they can NOT see the show page" do
      expect{ visit defence_request_path(dr2) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end