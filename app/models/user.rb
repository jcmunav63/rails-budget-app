class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true
  has_many :categories, foreign_key: :user_id, class_name: 'Category'
  has_many :expenses, foreign_key: :author_id, class_name: 'Expense'

  # User::Roles
  enum role: %i[default admin].freeze

  def admin?
    role == 'admin'
  end

  def is?(requested_role)
    role == requested_role.to_s
  end
end
