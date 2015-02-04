require 'rails_helper'

RSpec.feature 'cso dashboard' do

  before do
    create_cso_and_login
    create_a_defence_request
  end

  scenario 'Closing a case' do
    visit defence_requests_path
    expect(page).to have_content 'Bob Smith'
    click_button 'Close'

    expect(page).to have_content "Defence Request successfully closed"
    expect(page).to_not have_content "Bob Smith"
  end

end
