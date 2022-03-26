class Category < ApplicationRecord
  has_many :transactions

  validates_presence_of :name

  enum transaction_type: { expense: 0, income: 1, internal: 2 }

  def self.default
    self.find_or_create_by!(name: 'Miscellaneous')
  end
end
