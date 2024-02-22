module ExpensesHelper
  def current_page?(path)
    request.path == path
  end
end
