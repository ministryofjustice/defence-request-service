module HelperMethods

  def create_a_defence_request
    visit new_defence_request_path
    within '.new_defence_request' do
      choose 'Own'
      within '.details' do
        fill_in 'Solicitor Name', with: 'Bob Smith'
        fill_in 'Solicitor Firm', with: 'Acme Solicitors'
        fill_in 'Phone Number', with: '0207 284 0000'
        fill_in 'Custody Number', with: '#CUST-01234'
        fill_in 'Offences', with: 'BadMurder'
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
      click_button 'Create Defence Request'
    end
  end

  def date_then_as_hash
    date = Time.at(1423757676).to_datetime
    { 'day' => date.day, 'month' => date.month, 'year' => date.year, 'min' => date.minute, 'hour' => date.hour }
  end

  def date_now_as_hash
    date = DateTime.current
    { 'day' => date.day, 'month' => date.month, 'year' => date.year, 'min' => date.minute, 'hour' => date.hour }
  end

  def twenty_one_years_ago_as_hash
    date = DateTime.current - 21.years
    { 'day' => date.day, 'month' => date.month, 'year' => date.year }
  end
end
