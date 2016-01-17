require 'spec_helper'
include FactoryGirl::Syntax::Methods
include SessionHelpers

describe 'edit user' do
  let(:email) { 'strongbad@example.com' }
  let(:new_email) { 'dangeresque@example.com' }
  let!(:user) { create :non_biolan, :confirmed, email: email }
  let!(:other_user) { create :non_biolan, :confirmed }

  before { admin_login }

  it 'updates the user' do
    click_link 'Users'
    expect(page).to have_content user.name
    expect(page).to have_content other_user.name

    fill_in 'q', with: user.name
    click_button 'Search'
    expect(page).to have_content user.name
    expect(page).to_not have_content other_user.name
    click_link user.name

    expect(page).to have_content user.name
    expect(page).to have_content user.uuid
    expect(page).to have_content user.first_name
    expect(page).to have_content user.last_name
    expect(page).to have_content user.email
    expect(page).to have_content user.referring_url
    expect(page).to have_content user.user_agent
    expect(page).to have_content user.ip_address

    click_link 'Edit'
    fill_in 'Email', with: new_email
    click_button 'Update User'

    expect(page).to have_content 'User updated'
    expect(page).to have_content "Email#{new_email}"
    expect(page).to_not have_content "Email#{email}"
  end
end
