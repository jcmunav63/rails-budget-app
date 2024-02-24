require 'rails_helper'

RSpec.describe 'Visit the New Category page', type: :system do
  scenario '- create a new category' do
    user = FactoryBot.create(:user)
    sign_in user
    visit new_user_category_path(user)

    fill_in 'Name', with: 'New Category'
    sleep(2)
    select 'Apple.png', from: 'icon'
    click_button 'Add Category'

    # Expect to be redirected to the Categories Index page
    expect(page).to have_current_path(user_categories_path(user))

    # Check that the newly created category is displayed
    expect(page).to have_content("New Category")

    # Verify that the total count of categories has increased by 1
    expect(Category.count).to eq(1)
  end

  scenario '- find the New Category content' do
    user = FactoryBot.create(:user)
    sign_in user
    visit new_user_category_path(user)

    fill_in 'Name', with: 'New Category'
    sleep(2)
    select 'Apple.png', from: 'icon'
    click_button 'Add Category'

    expect(page).to have_content('New Category')
  end
end
