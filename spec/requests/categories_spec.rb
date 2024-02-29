require 'rails_helper'

RSpec.describe 'Categories', type: :request do
  include Rails.application.routes.url_helpers
  describe 'GET /index' do
    # user = User.create(id: 1, name: 'John Smith', email: 'johnsmith@gmail.com', password: 'me1234')
    # before { get user_categories_path(user) }
    it 'returns a successful response' do
      user = FactoryBot.create(:user)
      Category.create(name: 'Test Category 1', icon: '/images/icon.png', total_expenses: '0.0',
                      user_id: user.id)
      Category.create(name: 'Test Category 2', icon: '/images/icon.png', total_expenses: '5.0',
                      user_id: user.id)
      Category.create(name: 'Test Category 3', icon: '/images/icon.png', total_expenses: '10.0',
                      user_id: user.id)
      sign_in user
      get user_categories_path(user)
      expect(response).to have_http_status(:success)
    end

    it "displays the title 'Categories Index'" do
      user = FactoryBot.create(:user)
      Category.create(name: 'Test Category 1', icon: '/images/icon.png', total_expenses: '0.0',
                      user_id: user.id)
      Category.create(name: 'Test Category 2', icon: '/images/icon.png', total_expenses: '5.0',
                      user_id: user.id)
      Category.create(name: 'Test Category 3', icon: '/images/icon.png', total_expenses: '10.0',
                      user_id: user.id)
      sign_in user
      get user_categories_path(user)
      expect(response.body).to include('CATEGORIES')
    end

    it 'displays each category with its icon, name, and total expenses' do
      user = FactoryBot.create(:user)
      category1 = FactoryBot.create(:category, user:, icon: '/images/icons/icon.png', name: 'Test Category 1',
                                               total_expenses: 0.0)
      category2 = FactoryBot.create(:category, user:, icon: '/images/icons/icon.png', name: 'Test Category 2',
                                               total_expenses: 5.0)
      category3 = FactoryBot.create(:category, user:, icon: '/images/icons/icon.png', name: 'Test Category 3',
                                               total_expenses: 10.0)
      sign_in user
      get user_categories_path(user)

      [category1, category2, category3].each do |category|
        expect(response.body).to include(category.icon)
        expect(response.body).to include(category.name)
        expect(response.body).to include("$#{category.total_expenses}")
      end
    end

    it "contains a 'New category' button" do
      user = FactoryBot.create(:user)
      Category.create(name: 'Test Category 1', icon: '/images/icon.png', total_expenses: '0.0',
                      user_id: user.id)
      Category.create(name: 'Test Category 2', icon: '/images/icon.png', total_expenses: '5.0',
                      user_id: user.id)
      Category.create(name: 'Test Category 3', icon: '/images/icon.png', total_expenses: '10.0',
                      user_id: user.id)
      sign_in user
      get user_categories_path(user)
      expect(response.body).to include('NEW CATEGORY')
    end
  end
end
