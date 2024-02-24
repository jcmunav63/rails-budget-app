require 'rails_helper'

RSpec.describe '- visits the New Expense page', type: :system do
  include Rails.application.routes.url_helpers

  let(:user) { FactoryBot.create(:user) }
  let(:category) { FactoryBot.create(:category, user: user) }

  before do
    sign_in user
  end

  describe '- Visits the New Expense page' do
    scenario '- creates a new expense' do
      visit new_user_category_expense_path(user, category)

      fill_in 'Name', with: 'Test Expense'
      fill_in 'Amount', with: 10.5
      click_button 'Create Expense'

      # Expect to be redirected to the Expenses Index page
      expect(page).to have_current_path(user_category_expenses_path(user, category))

      # Check that the newly created expense is displayed
      expect(page).to have_content("Test Expense")

      # Verify that the total count of categories has increased by 1
      expect(Expense.count).to eq(1)
    end

    scenario '- verifies the content of  the new expense page' do
      visit new_user_category_expense_path(user, category)

      expect(page).to have_content('New Expense for: ')
      expect(page).to have_button('Create Expense')

      fill_in 'Name', with: 'Test Expense'
      fill_in 'Amount', with: 10.5
      click_button 'Create Expense'

      expect(page).to have_content('Add Expense')
    end
  end
end
