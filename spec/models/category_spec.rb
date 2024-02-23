require 'rails_helper'

RSpec.describe Category, type: :model do
  describe 'associations' do
    it '- has association with an author' do
      association = described_class.reflect_on_association(:user)
      expect(association.options[:class_name]).to eq('User')
      expect(association.foreign_key).to eq('user_id')
    end

    it '- has association with category_expenses' do
      association = described_class.reflect_on_association(:category_expenses)
      expect(association.options[:class_name]).to eq('CategoryExpense')
      expect(association.foreign_key).to eq('category_id')
    end

    it 'has many category_expenses' do
      author = User.create(name: 'Test User', email: 'test@example.com', password: 'password')
      category = Category.create(name: 'Test Category', icon: '/images/icon.png', total_expenses: '0.0', user_id: author.id)
      expense1 = Expense.create(author_id: author.id, name: 'Expense 1', amount: 50)
      expense2 = Expense.create(author_id: author.id, name: 'Expense 2', amount: 100)
      category_expense1 = CategoryExpense.create(category_id: category.id, expense_id: expense1.id)
      category_expense2 = CategoryExpense.create(category_id: category.id, expense_id: expense2.id)

      expect(category.category_expenses).to include(category_expense1)
      expect(category.category_expenses).to include(category_expense2)
    end
  end

  describe 'validations' do
    it 'requires name to be present' do
      category = Category.new(name: '', icon: '/images/icon.png', total_expenses: '0.0')
      category.valid?
      expect(category.errors[:name]).to include("can't be blank")
    end

    it 'requires icon to be present' do
      category = Category.new(name: 'Food - Mc Donald\s', icon: '', total_expenses: '0.0')
      category.valid?
      expect(category.errors[:icon]).to include("can't be blank")
    end
  end
end
