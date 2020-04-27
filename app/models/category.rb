class Category < ApplicationRecord
  has_many :transactions

  validates_presence_of :name
end
