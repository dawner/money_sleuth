class Transaction < ApplicationRecord
  enum status: { draft: 0, confirmed: 1, deleted: 2 }

  belongs_to :bank
  belongs_to :category

  monetize :value
end
