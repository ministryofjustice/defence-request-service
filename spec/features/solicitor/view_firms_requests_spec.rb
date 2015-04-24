require "rails_helper"

RSpec.feature "Solicitors viewing their firm's requests" do
  specify "can see defence requests" do
    solicitor = create :solicitor_user
    another_solicitor = create :solicitor_user
    firms_defence_request =
      create(
        :defence_request,
        :aborted,
        solicitor_uid: nil,
        organisation_uid: solicitor.organisation_uids.first,
        offences: 'Arson'
    )
    other_firms_defence_request =
      create(
        :defence_request,
        :aborted,
        solicitor_uid: nil,
        organisation_uid: another_solicitor.organisation_uids.first,
        offences: 'Extortion'
    )

    login_with_user solicitor

    expect(page).to     have_content firms_defence_request.offences
    expect(page).to_not have_content other_firms_defence_request.offences
  end
end
