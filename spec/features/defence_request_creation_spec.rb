require 'rails_helper'

RSpec.feature 'defence request creation' do

  before do
    create_cso_and_login
  end

  scenario 'selecting duty solicitor' do
    visit new_defence_request_path
    expect(page).to have_content ('New Defence Request')
    choose 'Duty'
  end

  scenario 'selecting own solicitor' do
    visit new_defence_request_path
    expect(page).to have_content ('New Defence Request')
    choose 'Own'
    page.fill_in 'q', with: 'Bob Smith'
  end

  scenario 'selecting own solicitor' do
    visit root_path
    click_link 'New Defence Request'
    expect(page).to have_content ('New Defence Request')


    within '.new_defence_request' do
      choose 'Own'
      within '.details' do
        fill_in 'Solicitor Name', with: 'Bob Smith'
        fill_in 'Solicitor Firm', with: 'Acme Solicitors'
        select('Brighton Scheme 1', from: 'defence_request[scheme]')
        fill_in 'Phone Number', with: '0207 284 0000'
        fill_in 'Custody Number', with: '#CUST-01234'
        fill_in 'Allegations', with: 'BadMurder'
        select('09', from: 'defence_request_time_of_arrival_4i')
        select('30', from: 'defence_request_time_of_arrival_5i')
      end

      within '.detainee' do
        fill_in 'Detainee Surname', with: 'Mannie'
        fill_in 'Detainee First Name', with: 'Badder'
        choose 'Male'
        check 'defence_request[adult]'
        select('1976', from: 'defence_request_date_of_birth_1i')
        select('January', from: 'defence_request_date_of_birth_2i')
        select('1', from: 'defence_request_date_of_birth_3i')
        check 'defence_request[appropriate_adult]'
      end
      fill_in 'Comments', with: 'This is a very bad man. Send him down...'
      click_button 'Create Defence request'
    end
    expect(page).to have_content 'Bob Smith'
  end

end
