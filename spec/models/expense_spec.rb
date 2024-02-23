require 'rails_helper'

RSpec.describe Expense, type: :model do
  describe 'associations' do
    it 'belongs to an author (user)' do
      association = described_class.reflect_on_association(:user)
      expect(association).not_to be_nil
      expect(association.macro).to eq(:belongs_to)
    end

    it 'has many category_expenses' do
      association = described_class.reflect_on_association(:category_expenses)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:class_name]).to eq('CategoryExpense')
    end
  end

  describe 'validations' do
    it 'requires name to be present' do
      author = User.create(name: 'Test User', email: 'test@example.com', password: 'password')
      expense = Expense.new(author_id: author.id, name: '', amount: 10.0)
      expense.valid?
      expect(expense.errors[:name]).to include("can't be blank")
    end

    it 'requires amount to be present' do
      author = User.create(name: 'Test User', email: 'test@example.com', password: 'password')
      expense = Expense.new(author_id: author.id, name: 'Example expense')
      expense.valid?
      expect(expense.errors[:amount]).to include("can't be blank")
    end

    it 'requires amount to be numeric' do
      author = User.create(name: 'Test User', email: 'test@example.com', password: 'password')
      expense = Expense.new(author_id: author.id, name: 'Example expense', amount: 'abc')
      expense.valid?
      expect(expense.errors[:amount]).to include('is not a number')
    end

    it 'requires amount to be greater than 0' do
      author = User.create(name: 'Test User', email: 'test@example.com', password: 'password')
      expense = Expense.new(author_id: author.id, name: 'Example expense', amount: 0)
      expense.valid?
      expect(expense.errors[:amount]).to include('must be greater than or equal to 0.01')
    end
  end
end
