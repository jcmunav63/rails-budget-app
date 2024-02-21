class CategoriesController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = current_user
    @categories = @user.categories.includes(:user)
    # .all.paginate(page: params[:page], per_page: 3)
  end

  def new
  end

  def create
  end

  def show
    @user = current_user
    @category = Category.find(params[:id])
    # .includes(category_expenses: :expense)
    # @category_expenses = @category.category_expenses
  end
end
