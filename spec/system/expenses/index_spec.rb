require 'rails_helper'

RSpec.describe 'Visit Expenses index page', type: :system do
  include Rails.application.routes.url_helpers

  let(:user) { FactoryBot.create(:user) }
  let(:category) { FactoryBot.create(:category, user:) }

  before do
    sign_in user
  end

  describe 'Visits the Expenses Index page' do
    scenario '- displays expenses associated with the selected category' do
      expense1 = FactoryBot.create(:expense, author_id: user.id)
      expense2 = FactoryBot.create(:expense, author_id: user.id)
      category.expenses << expense1
      category.expenses << expense2
      category.update(total_expenses: category.total_expenses + expense1.amount + expense2.amount)
      visit user_category_expenses_path(user, category)
      sleep(3)

      expect(page).to have_content(expense1.name)
      expect(page).to have_content(format('$%.2f', expense1.amount))

      expect(page).to have_content(expense2.name)
      expect(page).to have_content(format('$%.2f', expense2.amount))
    end

    scenario '- displays content of the selected category' do
      expense1 = FactoryBot.create(:expense, author_id: user.id)
      expense2 = FactoryBot.create(:expense, author_id: user.id)
      category.expenses << expense1
      category.expenses << expense2
      category.update(total_expenses: category.total_expenses + expense1.amount + expense2.amount)
      visit user_category_expenses_path(user, category)
      sleep(3)

      expect(page).to have_content(category.name)
      expect(page).to have_content(format('$%.2f', category.total_expenses))
    end
  end
end
