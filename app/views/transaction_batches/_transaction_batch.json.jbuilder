json.extract! transaction_batch, :id, :upload_ref, :bank_id, :created_at, :updated_at
json.url transaction_batch_url(transaction_batch, format: :json)
