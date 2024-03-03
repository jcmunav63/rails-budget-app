class CategoryExpense < ApplicationRecord
  belongs_to :category, class_name: 'Category', foreign_key: :category_id
  belongs_to :expense
end
