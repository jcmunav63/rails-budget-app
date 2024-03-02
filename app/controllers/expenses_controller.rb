class ExpensesController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = current_user
    @category = Category.find(params[:category_id])
    # Retrieve expenses associated with the current user (author) and, then,
    # includes the category_expenses associated with the corresponding category
    @author = @user
    @expenses = Expense.includes(:category_expenses)
      .where(author_id: @user.id, category_expenses: { category_id: @category.id })
      .order(created_at: :desc)
    # Calculate total expenses
    @total_expenses = @expenses.sum(:amount)
  end

  def new
    @category = Category.find(params[:category_id])
    @categories = current_user.categories.where.not(id: @category.id)
    @expense = Expense.new
  end

  def create
    @category = Category.find(params[:category_id])
    @categories = current_user.categories.where.not(id: @category.id)
    @amount = params[:amount]
    @name = params[:name]
    selected_category_ids = params[:expense][:categories].reject(&:empty?).map(&:to_i)
    if selected_category_ids.empty?
      @expense = @category.expenses.build(expense_params)
      @expense.author_id = current_user.id

      # Create a corresponding CategoryExpense record
      @category_expense = @category.category_expenses.create(expense_id: @expense.id)
      # Update the total_expenses for the associated category
      @category.update(total_expenses: @category.total_expenses + @expense.amount)
      redirect_to user_category_expenses_path(current_user, @category),
                  alert: 'Expense was successfully created.'
    else
      save_for_two_categories(@category, selected_category_ids, @amount, @name)
      redirect_to user_category_expenses_path(current_user, @category)
      flash[:alert] = if selected_category_ids.length > 1
                        'Only one additional category permitted.'
                      else
                        'Created Expense for two categories.'
                      end
    end
  rescue StandardError => e
    redirect_to user_category_expenses_path(current_user, @category),
                alert: "Error creating expenses: #{e.message}"
  end

  def save_for_two_categories(category, selected_category_ids)
    @total_categories = selected_category_ids.length + 1
    return unless @total_categories == 2

    @expense = category.expenses.build(expense_params)
    @expense.author_id = current_user.id
    return unless @expense.save

    @half = @expense.amount / 2
    @expense.update(amount: @expense.amount - @half)
    # Create a corresponding CategoryExpense record
    @category_expense = category.category_expenses.create(expense_id: @expense.id)
    # Update the total_expenses for the associated category
    category.update(total_expenses: category.total_expenses + @half)

    # Create second Expense (second category with half of amountl)
    @category2 = Category.find(selected_category_ids[0])
    @expense2 = Expense.new
    @expense2 = @category2.expenses.build(expense_params)
    @expense2.author_id = current_user.id
    if @expense2.save
      @expense2.update(amount: @expense2.amount - @half)
      # Create a corresponding CategoryExpense record
      @category_expense2 = @category2.category_expenses.create(expense_id: @expense2.id)
      # Update the total_expenses for the associated category
      @category2.update(total_expenses: @category2.total_expenses + @half)
    else
      flash[:alert] = "Failed to create the Expense for the second category: #{e.message}"
    end
  end

  private

  def expense_params
    params.require(:expense).permit(:name, :amount, :categories)
  end
end
