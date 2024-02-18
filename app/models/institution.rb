class Institution < ApplicationRecord
  has_many :accounts, dependent: :destroy

  validates_presence_of :name, :slug
end
