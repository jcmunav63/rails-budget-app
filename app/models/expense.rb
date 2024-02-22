class Expense < ApplicationRecord
  belongs_to :user, foreign_key: :author_id

  has_many :category_expenses, dependent: :destroy
  has_many :categories, through: :category_expenses

  validates :name, presence: true
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0.01 }
end
