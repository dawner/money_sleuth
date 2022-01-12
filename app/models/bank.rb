class Bank < ApplicationRecord
  has_many :transaction_batches, dependent: :destroy
  has_many :balance_entries, dependent: :destroy

  validates_presence_of :name, :slug, :headers
  validate :includes_required_headers

  REQUIRED_HEADERS = ['posted_on', 'description', 'value']

  def includes_required_headers
    unless (REQUIRED_HEADERS-headers).empty?
      errors.add(:headers, "must contain: #{REQUIRED_HEADERS}")
    end
  end
end
