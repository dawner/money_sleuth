class Account < ApplicationRecord
  belongs_to :institution

  validates_presence_of :name

  enum account_type: { bank: 0, investment: 1, credit_card: 2, retirement: 3 }

end