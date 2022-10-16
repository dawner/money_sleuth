module TransactionsHelper
  def filter_options(filter_key, existing_filters)
    path_with_params = transactions_path(existing_filters.except(filter_key))
    { data: { remote: true, method: :get, url: path_with_params }}
  end
end
