module ApplicationHelper
  def all_categories_grouped
    @categories ||= Category.all
        .order(:name)
        .group_by(&:transaction_type)
        .map { |type, categories| OpenStruct.new({ name: type.humanize, categories: categories })}
  end
end
