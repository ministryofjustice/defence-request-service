require 'rails_helper'

RSpec.feature 'user authentication' do
  context  'cso with authentication' do
    let(:cso_password) { 'password' }
    let(:cso_user) { User.create(email: 'cso@example.com', password: cso_password, role: :cso) }

    scenario 'logs in with valid credentials' do
      visit new_user_session_path
      fill_in 'user_email', with: cso_user.email
      fill_in 'user_password', with: cso_password
      click_button 'Sign in'
      expect(page).to have_content('CSO Dashboard')
    end

    scenario 'logs in with invalid credentials' do
      visit new_user_session_path
      fill_in 'user_email', with: cso_user.email
      fill_in 'user_password', with: 'notarealpassword'
      click_button 'Sign in'
      expect(page).to_not have_content('CSO Dashboard')
    end
  end

  context 'cco with authentication' do
    let(:cco_password) { 'password' }
    let(:cco_user) { User.create(email: 'cco@example.com', password: cco_password, role: :cco) }

    scenario 'logs in with valid credentials' do
      visit new_user_session_path
      fill_in 'user_email', with: cco_user.email
      fill_in 'user_password', with: cco_password
      click_button 'Sign in'
      expect(page).to have_content('CCO Dashboard')
    end

    scenario 'logs in with invalid credentials' do
      visit new_user_session_path
      fill_in 'user_email', with: cco_user.email
      fill_in 'user_password', with: 'notarealpassword'
      click_button 'Sign in'
      expect(page).to_not have_content('CCO Dashboard')
    end
  end

  context 'unauthenticated' do
    scenario 'logs in with valid credentials' do
      visit root_path
      expect(page).to have_button('Sign in')
    end
  end
end
