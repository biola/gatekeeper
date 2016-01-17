require 'spec_helper'
include FactoryGirl::Syntax::Methods
include SessionHelpers

describe 'delete account' do
  let(:password) { Faker::Internet.password }
  let(:user) { create :non_biolan, :confirmed, password: password }

  it 'update the user info' do
    login_with user.username, password

    click_link 'Delete Account'

    expect(page).to have_content 'Are you sure you want to delete your account?'
    expect(page).to have_current_path '/user/delete'

    click_button 'Delete Account'

    expect(page).to have_content 'Account deleted'
    expect(page).to have_current_path '/'

    fill_in 'Username', with: user.username
    fill_in 'Password', with: password
    click_button 'Login'

    expect(page).to have_content 'Invalid username or password'
  end
end
