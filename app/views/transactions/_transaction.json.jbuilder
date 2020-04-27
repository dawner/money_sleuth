json.extract! transaction, :id, :posted_on, :description, :amount, :state, :transaction_batch_id, :category_id, :created_at, :updated_at
json.url transaction_url(transaction, format: :json)
