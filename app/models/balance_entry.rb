class BalanceEntry < ApplicationRecord
  belongs_to :bank

  monetize :value_cents

  validates_presence_of :posted_on, :value_cents, :bank_id
end
