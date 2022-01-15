class BalanceEntry < ApplicationRecord
  belongs_to :institution
  belongs_to :account

  monetize :value_cents

  validates_presence_of :posted_on, :value_cents, :institution_id
end
