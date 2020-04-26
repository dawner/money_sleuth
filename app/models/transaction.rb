class Transaction < ApplicationRecord
  enum status: { draft: 0, confirmed: 1, deleted: 2 }

  belongs_to :transaction_batch
  belongs_to :category

  monetize :value
end
