class BalanceEntry < ApplicationRecord
  belongs_to :institution

  monetize :value_cents

  validates_presence_of :posted_on, :value_cents, :institution_id
end
