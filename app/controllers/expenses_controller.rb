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

    @expense = @category.expenses.build
  end

  def create
    @category = Category.find(params[:category_id])

    selected_category_ids = params[:expense][:categories].reject(&:blank?).map(&:to_i)
    total_categories = selected_category_ids.count + 1
    total_amount = params[:expense][:amount].to_f

    if total_categories > 1
      # Calculate the amount for each category
      amount_per_category = total_amount / total_categories
    else
      amount_per_category = total_amount
    end

    ActiveRecord::Base.transaction do
      [category.id] + selected_category_ids.each do |category_id|
        # Create expense for each category
        expense = Expense.create(
          name: params[:expense][:name],
          amount: amount_per_category,
          author_id: current_user.id
        )
        
        # Create CategoryExpense record
        CategoryExpense.create(
          category_id: category_id,
          expense_id: expense.id,
          amount: amount_per_category
        )
        
        # Update the total_expenses for each category
        Category.find(category_id).update(total_expenses: Category.find(category_id).total_expenses + amount_per_category)
      end
    end
    redirect_to user_category_expenses_path(current_user, @category), notice: 'One or more expenses were created
      successfully.'
  rescue
    flash[:alert] = "Error creating expenses: #{e.message}"
    render :new
  end

  private

  def expense_params
    params.require(:expense).permit(:name, :amount)
  end
end
