module CategoriesHelper
  def current_page?(path)
    request.path == path
  end
end
