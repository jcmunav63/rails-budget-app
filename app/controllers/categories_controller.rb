class CategoriesController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = current_user
    @categories = @user.categories.includes(:user) # .all.paginate(page: params[:page], per_page: 3)
  end
end
