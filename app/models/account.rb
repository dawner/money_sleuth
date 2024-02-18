class Account < ApplicationRecord
  belongs_to :institution
  has_many :balance_entries, dependent: :destroy
  has_many :transaction_batches, dependent: :destroy

  validates_presence_of :name, :headers
  validate :includes_required_headers

  enum account_type: { bank: 0, investment: 1, credit_card: 2, retirement: 3 }

  scope :active, -> { where(active: true) }

  LIQUID_TYPES = ['bank', 'credit_card']
  DEFAULT_HEADERS = ['posted_on', 'description', 'value']

  def includes_required_headers
    unless (['posted_on', 'description']-headers).empty?
      errors.add(:headers, "must contain: 'posted_on', 'description' and 'value' or 'expense_value'")
    end

    unless headers.include?('value') || headers.include?('expense_value')
      errors.add(:headers, "must contain either value or expense_value")
    end
  end

  def liquid?
    LIQUID_TYPES.include?(account_type)
  end
end
