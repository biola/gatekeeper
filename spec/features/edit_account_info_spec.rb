require 'spec_helper'
include FactoryGirl::Syntax::Methods
include SessionHelpers

describe 'edit account info' do
  let(:password) { Faker::Internet.password }
  let(:user) { create :non_biolan, :confirmed, password: password }

  context 'with invalid data' do
    it 'shows an error message' do
      login_with user.username, password

      fill_in 'Last name', with: ''
      click_button 'Update Account'

      expect(page).to have_content "Last name can't be blank"
      expect(find_field('Last name').value).to eql ''
    end
  end

  context 'with valid data' do
    it 'updates the user info' do
      login_with user.username, password

      fill_in 'Last name', with: 'Bad'
      click_button 'Update Account'

      expect(page).to have_content 'Changes saved'
      expect(find_field('Last name').value).to eql 'Bad'
    end
  end
end
