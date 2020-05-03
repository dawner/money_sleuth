class TransactionBatch < ApplicationRecord
  belongs_to :bank
  has_many :transactions, dependent: :destroy

  mount_uploader :bank_file, BankFileUploader

  validates_presence_of :bank, :bank_file
end
