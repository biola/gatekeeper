require 'spec_helper'
include FactoryGirl::Syntax::Methods

describe 'forgot password' do
  let(:user) { create :non_biolan, :confirmed }

  before { clear_emails }

  context 'with bogus email' do
    it 'gives an error message' do
      visit root_path
      click_link 'Forgot password?'
      fill_in 'Email', with: 'strongbad@example.com'
      click_button 'Reset Password'

      expect(page).to have_content 'No user account with that email was found'
      expect(page).to have_current_path '/forgot_passwords/new'
    end
  end

  context 'with valid email' do
    it 'resets and emails a new password' do
      visit root_path
      click_link 'Forgot password?'
      fill_in 'Email', with: user.email
      click_button 'Reset Password'

      expect(page).to have_content /Your password reset link has been sent/
      open_email user.email

      expect(current_email.subject).to eql 'Your password reset link'
      visit current_email.body.scan(/\s(https?:\/\/.*\/forgot_passwords\/.*)\s/).join

      expect(page).to have_content 'Reset Forgotten Password'
      fill_in 'non_biolan[password]', with: 'stort'
      fill_in 'non_biolan[password_confirmation]', with: 'short'
      click_button 'Change Password'

      expect(page).to have_content 'Password is too short'

      fill_in 'non_biolan[password]', with: 'onething'
      fill_in 'non_biolan[password_confirmation]', with: 'anotherthing'
      click_button 'Change Password'

      expect(page).to have_content "Password confirmation doesn't match"

      fill_in 'non_biolan[password]', with: 'letmeinplease'
      fill_in 'non_biolan[password_confirmation]', with: 'letmeinplease'
      click_button 'Change Password'

      expect(page).to have_content 'Your password has been changed'
      expect(page).to have_current_path '/user/edit'
    end

    context 'when trying to reuse a password reset link' do
      it '404s' do
        visit root_path
        click_link 'Forgot password?'
        fill_in 'Email', with: user.email
        click_button 'Reset Password'

        open_email user.email
        password_reset_url = current_email.body.scan(/\s(https?:\/\/.*\/forgot_passwords\/.*)\s/).join
        visit password_reset_url

        fill_in 'non_biolan[password]', with: 'letmeinplease'
        fill_in 'non_biolan[password_confirmation]', with: 'letmeinplease'
        click_button 'Change Password'

        expect { visit password_reset_url }.to raise_error Mongoid::Errors::DocumentNotFound
      end
    end

    context 'with an expired password' do
      before { expect(Settings.password).to receive(:reset_expire).and_return -1 }

      it '404s' do
        visit root_path
        click_link 'Forgot password?'
        fill_in 'Email', with: user.email
        click_button 'Reset Password'

        open_email user.email
        password_reset_url = current_email.body.scan(/\s(https?:\/\/.*\/forgot_passwords\/.*)\s/).join
        expect { visit password_reset_url }.to raise_error Mongoid::Errors::DocumentNotFound
      end
    end
  end
end
