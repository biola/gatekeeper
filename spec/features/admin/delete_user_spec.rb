require 'spec_helper'
include FactoryGirl::Syntax::Methods
include SessionHelpers

describe 'edit user' do
  let!(:user) { create :non_biolan, :confirmed }
  let!(:other_user) { create :non_biolan, :confirmed }

  before { admin_login }

  it 'deletes the user' do
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

    click_link 'Delete User'
    expect(page).to have_content 'User deleted'
    expect(page).to have_content 'Deleted User'
    expect(page).to have_content user.uuid
    expect(page).to have_content user.first_name
    expect(page).to have_content user.last_name
    expect(page).to_not have_content other_user.name
  end
end
