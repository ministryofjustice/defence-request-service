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
      expect(page).to have_content('Custody Suite Officer Dashboard')
    end

    scenario 'logs in with invalid credentials' do
      visit new_user_session_path
      fill_in 'user_email', with: cso_user.email
      fill_in 'user_password', with: 'notarealpassword'
      click_button 'Sign in'
      expect(page).to_not have_content('Custody Suite Officer Dashboard')
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
      expect(page).to have_content('Call Center Operative Dashboard')
    end

    scenario 'logs in with invalid credentials' do
      visit new_user_session_path
      fill_in 'user_email', with: cco_user.email
      fill_in 'user_password', with: 'notarealpassword'
      click_button 'Sign in'
      expect(page).to_not have_content('Call Center Operative Dashboard')
    end
  end

  context 'solicitor with authentication' do
    let(:solicitor_password) { 'password' }
    let(:solicitor_user) { User.create(email: 'solicitor@example.com', password: solicitor_password, role: :solicitor) }

    scenario 'logs in with valid credentials' do
      visit new_user_session_path
      fill_in 'user_email', with: solicitor_user.email
      fill_in 'user_password', with: solicitor_password
      click_button 'Sign in'
      expect(page).to have_content('Solicitor Dashboard')
    end

    scenario 'logs in with invalid credentials' do
      visit new_user_session_path
      fill_in 'user_email', with: solicitor_user.email
      fill_in 'user_password', with: 'notarealpassword'
      click_button 'Sign in'
      expect(page).to_not have_content('Solcitior Dashboard')
    end
  end


  context 'unauthenticated' do
    scenario 'logs in with valid credentials' do
      visit root_path
      expect(page).to have_button('Sign in')
    end
  end
end
