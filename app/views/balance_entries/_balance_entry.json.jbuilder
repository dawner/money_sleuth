json.extract! balance_entry, :id, :posted_on, :value, :bank_id, :created_at, :updated_at
json.url balance_entry_url(balance_entry, format: :json)
