class ExpensesController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = current_user
    @category = Category.find(params[:category_id])

    # Retrieve expenses associated with the current user (author)
    @author = @user
    @expenses = Expense.where(author_id: @user.id)

    # Join with category_expenses table to filter expenses associated with the specific category
    @expenses = @expenses.joins(:category_expenses).where(category_expenses: { category_id: @category.id })

    # Order expenses by created_at in descending order
    @expenses = @expenses.order(created_at: :desc)

    # Calculate total expenses
    @total_expenses = @expenses.sum(:amount)
  end

  def new
    @category = Category.find(params[:category_id])
    @expense = @category.expenses.build
  end

  def create
    @category = Category.find(params[:category_id])
    @expense = @category.expenses.build(expense_params)
    @expense.author_id = current_user.id

    if @expense.save
      # Create a corresponding CategoryExpense record
      @category_expense = @category.category_expenses.create(expense_id: @expense.id)

      # Update the total_expenses for the associated category
      @category.update(total_expenses: @category.total_expenses + @expense.amount)

      redirect_to user_category_expenses_path(current_user, @category), notice: 'Expense was successfully created.'
    else
      render :new
    end
  end

  private

  def expense_params
    params.require(:expense).permit(:name, :amount)
  end
end
