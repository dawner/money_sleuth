module ApplicationHelper
  def all_categories
    @categories ||= Category.all.order(:name)
  end
end
