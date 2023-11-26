class TransactionBatch < ApplicationRecord
  belongs_to :account
  has_many :transactions, dependent: :destroy

  mount_uploader :file, InstitutionFileUploader

  validates_presence_of :account, :file
end
