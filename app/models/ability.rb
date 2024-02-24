class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.admin?
      can :manage, :all
    else
      can :read, :all
      can :manage, Category, user_id: user.id
      can :manage, Expense, author_id: user.id
      can :manage, CategoryExpense, category: { user_id: user.id }
      can :create, Category
      can :create, Expense

      # Check these options when implemented
      can :destroy, Category do |category|
        category.user == user
      end
      can :destroy, Expense do |expense|
        expense.user == user
      end
      can :destroy, CategoryExpense do |category_expense|
        category_expense.category.user == user
      end
    end
  end
end
