class Category < ApplicationRecord
  has_many :transactions

  validates_presence_of :name

  def self.default
    self.find_or_create_by!(name: 'Miscellaneous')
  end
end
