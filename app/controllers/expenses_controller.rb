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
    # @expense = Expense.new

    puts @category.inspect
    puts @categories.inspect
    puts @expense.inspect
  end

  def create
    @category = Category.find(params[:category_id])
    puts @category.inspect

    selected_category_ids = params[:expense][:categories].reject(&:empty?).map(&:to_i)

    if selected_category_ids.empty?
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
    else
      # total_categories = selected_category_ids.length + 1
      # category_expense_amount = params[:expense][:amount].to_f / total_categories
      # selected_category_ids = [category.id] + selected_category_ids

      # selected_category_ids.each do |category_id|
      #   expense = Expense.new(expense_params)
      #   expense.author_id = current_user.id
      #   expense.amount = category_expense_amount

      #   CategoryExpense.transaction do
      #     expense.save!
      #     CategoryExpense.create!(category_id: category_id, expense_id: expense.id)

      #     category = Category.find(category_id)
      #     category.update!(total_expenses: category.total_expenses + category_expense_amount)
      #   end
      # end

      flash[:notice] = 'Some Expenses about to be created.'
      redirect_to user_category_expenses_path(current_user, @category)
    end
  rescue StandardError => e
    flash[:alert] = "Error creating expenses: #{e.message}"
    render :new
  end

  private

  def expense_params
    params.require(:expense).permit(:name, :amount)
  end
end
