class CategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_icon_options, only: [:new, :create]

  def index
    @user = current_user
    @categories = @user.categories.includes(:user)
    # .all.paginate(page: params[:page], per_page: 3)
  end

  def new
    @category = current_user.categories.build
    # @layout_category = @category # check
    # render layout: 'application' # check
  end

  def create
    @user = current_user
    @category = @user.categories.build(category_params)

    if @category.save
      redirect_to user_categories_path(@user), notice: 'Category was successfully created!'
    else
      flash.now[:alert] = 'Failed to create Category: its name must be unique.'
      render :new
    end
  end

  def show
    @user = current_user
    @category = Category.find(params[:id])
    # .includes(category_expenses: :expense)
    # @category_expenses = @category.category_expenses
  end

  private

  def category_params
    params.require(:category).permit(:name, :icon, :total_expenses)
  end

  def set_icon_options
    @icon_options = Dir.glob("app/assets/images/icons/*").map do |file_path|
      file_name = File.basename(file_path)
      ["#{file_name.capitalize.gsub('_', ' ')}", ActionController::Base.helpers.asset_path("icons/#{file_name}")]
    end
  end
end
