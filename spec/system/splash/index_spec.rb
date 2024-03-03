require 'rails_helper'

RSpec.describe 'Splash screen page', type: :system do
  scenario 'Visit splash screen - finds page\'s header and subtitle' do
    visit root_path
    expect(page).to have_content('Smart Budget App')
    expect(page).to have_content('Manage your expenses wisely!')
  end

  scenario 'Visit splash screen - finds two link\'s content' do
    visit root_path
    expect(page).to have_link('LOG IN', href: new_user_session_path)
    expect(page).to have_link('SIGN UP', href: new_user_registration_path)
  end
end
