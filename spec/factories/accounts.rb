FactoryBot.define do
  factory :account do
    name { "Account Name" }
    account_type { 0 }
    institution
    headers { Account::DEFAULT_HEADERS }
    date_format { "%m/%d/%Y" }
    headers_in_file { true }
  end
end
