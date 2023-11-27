class Account < ApplicationRecord
  belongs_to :institution
  has_many :balance_entries, dependent: :destroy
  has_many :transaction_batches, dependent: :destroy

  validates_presence_of :name

  enum account_type: { bank: 0, investment: 1, credit_card: 2, retirement: 3 }

  LIQUID_TYPES = ['bank', 'credit_card']

  scope :active, -> { where(active: true) }

  def liquid?
    LIQUID_TYPES.include?(account_type)
  end
end
