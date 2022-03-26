FactoryBot.define do
  factory :transaction do
    category
    transaction_batch
    state { 0 }
    posted_on { "2020-04-27" }
    description { "Big long line of description words" }
    value_cents { 0 }
  end
end
