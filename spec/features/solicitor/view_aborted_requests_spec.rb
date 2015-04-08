require "rails_helper"

RSpec.feature "Solicitors viewing aborted requests" do

  let!(:aborted_dr) { create(:defence_request, :aborted, solicitor: create(:solicitor_user) ) }

  before :each do
    login_as_user(aborted_dr.solicitor.email)
  end

  specify 'can see "aborted" defence requests' do
    visit defence_requests_path

    within '.aborted-defence-request' do
      click_link('Show')
    end
    expect_to_see_reason_aborted aborted_dr
    expect(page).to have_content("Please call the Call Centre on 0999 999 9999") #TODO: this needs filling in

    expect_to_see_defence_request_values aborted_dr
  end

end
