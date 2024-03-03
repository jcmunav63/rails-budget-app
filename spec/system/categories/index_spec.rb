require 'rails_helper'

RSpec.describe 'Visit Categories index page', type: :system do
  scenario 'Visit categories index page - finds page\'s header' do
    user = FactoryBot.create(:user)
    FactoryBot.create(:category, user:, name: 'Category 1', total_expenses: 100)
    FactoryBot.create(:category, user:, name: 'Category 2', total_expenses: 200)

    login_as(user, scope: :user)
    visit user_categories_path(user)

    expect(page).to have_content('CATEGORIES')
  end

  scenario 'Visit categories index page - finds two button\'s links' do
    user = FactoryBot.create(:user)
    category1 = FactoryBot.create(:category, user:, name: 'Category 1', total_expenses: 100)
    category2 = FactoryBot.create(:category, user:, name: 'Category 2', total_expenses: 200)

    login_as(user, scope: :user)
    visit user_categories_path(user)

    expect(page).to have_link(category1.name)
    expect(page).to have_link(category2.name)
  end

  scenario 'Visit categories index page - finds two categories content' do
    user = FactoryBot.create(:user)
    category1 = FactoryBot.create(:category, user:, name: 'Category 1', total_expenses: 100)
    category2 = FactoryBot.create(:category, user:, name: 'Category 2', total_expenses: 200)

    login_as(user, scope: :user)
    visit user_categories_path(user)

    expect(page).to have_content("$#{category1.total_expenses}")
    expect(page).to have_content("$#{category2.total_expenses}")
  end
end
