require "rails_helper"

RSpec.feature "Custody Center Operatives viewing aborted requests" do
  specify "can see 'aborted' defence requests" do
    cco_user = create :cco_user
    aborted_defence_request = create :defence_request, :aborted

    login_with cco_user
    click_link "Completed (1)"
    click_link "Show"

    expect(page).
      to have_content "This case has been aborted for the following reason"
    expect(page).to have_content aborted_defence_request.reason_aborted
  end
end
