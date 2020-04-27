class Bank < ApplicationRecord
  has_many :transaction_batches, dependent: :destroy

  validates_presence_of :name, :slug
end
