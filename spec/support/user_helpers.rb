module UserHelpers
  # Obviously the passed in user should be initialized but not persisted
  def create_account_for(user, password = nil)
    password ||= Faker::Internet.password

    visit root_path
    fill_in 'First name', with: user.first_name
    fill_in 'Last name', with: user.last_name
    fill_in 'Email', with: user.email
    fill_in 'non_biolan[password]', with: password
    fill_in 'non_biolan[password_confirmation]', with: password
    click_button 'Create Account'
  end
end
