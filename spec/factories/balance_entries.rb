FactoryBot.define do
  factory :balance_entry do
    posted_on { "2022-01-11" }
    value { 5 }
    account
  end
end
