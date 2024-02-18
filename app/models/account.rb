class Account < ApplicationRecord
  belongs_to :institution
  has_many :balance_entries, dependent: :destroy
  has_many :transaction_batches, dependent: :destroy

  validates_presence_of :name, :headers
  validate :includes_required_headers

  enum account_type: { bank: 0, investment: 1, credit_card: 2, retirement: 3 }

  scope :active, -> { where(active: true) }

  LIQUID_TYPES = ['bank', 'credit_card']
  REQUIRED_HEADERS = ['posted_on', 'description', 'value']

  def includes_required_headers
    unless (REQUIRED_HEADERS-headers).empty?
      errors.add(:headers, "must contain: #{REQUIRED_HEADERS}")
    end
  end

  def liquid?
    LIQUID_TYPES.include?(account_type)
  end
end
