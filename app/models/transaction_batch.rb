class TransactionBatch < ApplicationRecord
  belongs_to :bank
  has_many :transactions, dependent: :destroy

  validates_presence_of :bank, :bank_file
end
