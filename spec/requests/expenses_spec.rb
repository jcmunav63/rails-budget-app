require 'rails_helper'

RSpec.describe 'Expenses', type: :request do
  include Rails.application.routes.url_helpers

  describe 'GET /expenses/index' do
    it 'returns http success' do
      user = FactoryBot.create(:user)
      sign_in user
      category = FactoryBot.create(:category, user:, total_expenses: 15.0)
      expense1 = FactoryBot.create(:expense, author_id: user.id, amount: 10.0)
      expense2 = FactoryBot.create(:expense, author_id: user.id, amount: 5.0)
      category.expenses << expense1
      category.expenses << expense2
      get user_category_expenses_path(user, category)
      expect(response).to have_http_status(:success)
    end
  end

  describe '/index displays expenses content' do
    it '- displays expenses associated with selected category' do
      user = FactoryBot.create(:user)
      sign_in user
      category = FactoryBot.create(:category, user:, total_expenses: 15.0)
      expense1 = FactoryBot.create(:expense, author_id: user.id, amount: 10.0)
      expense2 = FactoryBot.create(:expense, author_id: user.id, amount: 5.0)
      category.expenses << expense1
      category.expenses << expense2

      get user_category_expenses_path(user, category)

      expect(response.body).to include(category.name)
      expect(response.body).to include(format('$%.2f', category.total_expenses))
      expect(response.body).to include(expense1.name)
      expect(response.body).to include(format('$%.2f', expense1.amount))
      expect(response.body).to include(expense2.name)
      expect(response.body).to include(format('$%.2f', expense2.amount))
    end
  end
end
