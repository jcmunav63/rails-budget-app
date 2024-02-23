class Category < ApplicationRecord
  belongs_to :user, class_name: 'User', foreign_key: :user_id

  has_many :category_expenses, foreign_key: :category_id, class_name: 'CategoryExpense', dependent: :destroy
  has_many :expenses, through: :category_expenses

  validates :name, presence: true
  validates :icon, presence: true
end
