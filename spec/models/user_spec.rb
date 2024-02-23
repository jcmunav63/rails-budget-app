require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it 'has association with expenses' do
      association = described_class.reflect_on_association(:expenses)
      expect(association.options[:class_name]).to eq('Expense')
    end

    it 'has many expenses' do
      author = User.create(name: 'Test User', email: 'test@example.com', password: 'password')
      expense1 = Expense.create(name: 'Expense 1', author_id: author.id, amount: '10.0')
      expense2 = Expense.create(name: 'Expense 2', author_id: author.id, amount: '15.0')

      expect(author.expenses).to include(expense1)
      expect(author.expenses).to include(expense2)
    end

    it 'has association with categories' do
      association = described_class.reflect_on_association(:categories)
      expect(association.options[:class_name]).to eq('Category')
    end

    it 'has many categories' do
      user = User.create(name: 'Test User', email: 'test@example.com', password: 'password')
      category1 = Category.create(name: 'Category 1',
                                  icon: '/images/icon.png', total_expenses: '0.0', user_id: user.id)
      category2 = Category.create(name: 'Category 2',
                                  icon: '/images/icon.png', total_expenses: '0.0', user_id: user.id)

      expect(user.categories).to include(category1)
      expect(user.categories).to include(category2)
    end
  end

  describe 'validations' do
    it 'requires name to be present' do
      user = User.new(name: '', email: 'johnsmith@gmail.com', password: 'me1234')
      user.valid?
      expect(user.errors[:name]).to include("can't be blank")
    end

    it 'requires password to have a minimum length of 6' do
      user = User.new(name: 'John Smith', email: 'johnsmith@gmail.com', password: 'me12')
      user.valid?
      expect(user.errors[:password]).to include('is too short (minimum is 6 characters)')
    end

    it 'requires email to be present' do
      user = User.new(name: 'John Smith', password: 'me1234')
      user.valid?
      expect(user.errors[:email]).to include("can't be blank")
    end
  end
end
