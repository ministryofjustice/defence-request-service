require 'rails_helper'

RSpec.feature 'defence request creation' do

  before do
    create_cso_and_login
  end

  scenario 'selecting duty solicitor' do
    visit new_defence_request_path
    expect(page).to have_content ('New Defence Request')
    choose "Duty Solicitor"
  end

  scenario 'selecting own solicitor' do
    visit new_defence_request_path
    expect(page).to have_content ('New Defence Request')
    choose "Own Solicitor"
    page.fill_in 'Search', :with => 'Bob Smith'
  end

end
