require "rails_helper"

RSpec.feature "Custody Center Operatives viewing aborted requests" do

  let!(:aborted_dr) { create(:defence_request, :aborted) }

  before :each do
    create_role_and_login("cco")
  end

  specify 'can see "aborted" defence requests' do
    visit defence_requests_path

    within '.aborted-defence-request' do
      click_link('Show')
    end
    expect_to_see_reason_aborted aborted_dr

    expect_to_see_defence_request_values aborted_dr
  end

end
