class TransactionBatch < ApplicationRecord
  belongs_to :institution
  has_many :transactions, dependent: :destroy

  mount_uploader :file, InstitutionFileUploader

  validates_presence_of :institution, :file
end
