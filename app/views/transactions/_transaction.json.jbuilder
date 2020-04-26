json.extract! transaction, :id, :posted_on, :description, :amount, :state, :upload_ref, :bank_id, :category_id, :created_at, :updated_at
json.url transaction_url(transaction, format: :json)
